import Foundation

class CurrencyLayerAPI: BaseAPIImpl, CurrencyConversionAPI {
        
    private enum Endpoints: String, APIable {
        
        var secure: Bool { false } // free account does not support secure access
        var baseURLString: String { "api.currencylayer.com" }
        var keyAndAccessToken: (key: String, token: String)? {( "access_key", Secrets.apiKey) }

        case availableCurrencies = "list"
        case convert
        case exchangeRates = "live"
    }
    
    @discardableResult
    func getCurrencies(completion: @escaping ([Currency]) -> Void) -> Cancelable? {
        
        let dbCurrencies = self.database.getCurrencies()
        
        guard dbCurrencies.count == 0 else { completion(dbCurrencies); return nil }
        guard let url = Endpoints.availableCurrencies.url else { completion([]); return nil }
        
        let dataTask = session.dataTaskToDeserialize(object: SupportedCurrencyLayerResponseImpl.self,
                                                     from: url) { [weak self] (result) in

            switch result {
            case .success(let response):
                self?.database.saveIfPossible(currencies: response.currencies)
                completion(response.currencies)
                
            case .failure:
                completion([Currency]())
            }
        }
        dataTask.resume()
        
        return dataTask
    }
    
    private enum ConversionParamKeys: String {
        case from, to, amount
        var value: String { rawValue }
    }
    
    @discardableResult
    func convert(fromCurrency: Currency,
                 amount: Double,
                 toCurrency: Currency,
                 completion:  @escaping (_ amount: Double?) -> Void) -> Cancelable? {
        guard amount > 0 else {
            completion(0)
            return nil
        }
        
        let roundedAmount = amount.rounded(toPlaces: 6)
        
        let parameters = [ConversionParamKeys.from.value: fromCurrency.abbreviation,
                          ConversionParamKeys.to.value: toCurrency.abbreviation,
                          ConversionParamKeys.amount.value: "\(roundedAmount)"]
        
        guard let url = Endpoints.convert.url(with: parameters) else {
            completion(nil)
            return nil
        }
        
        let dataTask = session.dataTaskToDeserialize(object: ConvertCurrencyLayerResponseImpl.self, from: url) { (result) in
            switch result {
            case .success(let response):
                completion(response.result)
            case .failure:
                completion(nil)
            }
        }
        dataTask.resume()
        
        return dataTask
    }
    
    /// Source is only supported on non free accounts
    /// will be converting to dollar amount and then to the converting to the target amounts.
    @discardableResult
    func exchangeRates(fromCurrency: Currency,
                       amount: Double,
                       completion: @escaping ([CurrencyExchangeRate]) -> Void) -> Cancelable? {
        guard amount > 0 else {
            completion([])
            return nil
        }
        
        /// Currently only saving usdollar into the database.  If higher privilege accounts are used then use **fromCurrency** instead
        if let usdollarRates = database.getExchangesRates(for: AppManager.config.currencyFactory.usDollarCurrency()){
            completion(_convert(amount: amount,
                                fromCurrency: fromCurrency,
                                to: usdollarRates))
            return nil
        }
        
        /// Validating endpoint URL
        guard let url = Endpoints.exchangeRates.url else { completion([]); return nil }

        let dataTask = session.dataTaskToDeserialize(object: ActiveCurrencyRatesResponseImpl.self,
                                                     from: url) { (result) in
            switch result {
            case .success(let response):
                
                self.database.saveIfPossible(currencyExchangeRates: response.rates)
                
                completion(self._convert(amount: amount,
                                         fromCurrency: fromCurrency,
                                         to: response.rates))
            case .failure:
                completion([])
            }
        }
        dataTask.resume()
        
        return dataTask
    }
    
    /// converts from currency's amount to usdollars then calculates te conversion to other currencies
    func _convert(amount: Double,
                  fromCurrency: Currency,
                  to usRates: CurrencyExchangeRates) -> [CurrencyExchangeRate] {
        
        var dollarAmount = amount
        var usExchangeRates = usRates.exchangeRates
        
        /// **fromCurrency** is not USD
        if fromCurrency.abbreviation != AppConstants.ISO4217_USD {
            
            /// does a conversion exist between **fromCurrency** to USD in the rates?
            guard let fromCurToDollarRate = usExchangeRates
                    .first(where: { $0.toCurrencyAbbrev == fromCurrency.abbreviation })?.rate else { return [] }
            
            dollarAmount = dollarAmount / fromCurToDollarRate
            
            /// removing fromCurrency from the rates because we don't want to display that
            usExchangeRates.removeAll(where: { $0.toCurrencyAbbrev == fromCurrency.abbreviation })
            
            
            /// adding **fromCurrency** to USD exchange rate to the list
            let usdExchangeRate = AppManager.config.currencyFactory.createExchangeRate(rate: dollarAmount,
                                                                                       fromCurAbbr: fromCurrency.abbreviation,
                                                                                       toCurAbbr:  AppConstants.ISO4217_USD)
            usExchangeRates.append(usdExchangeRate)
            usExchangeRates.sort { $0.toCurrencyAbbrev < $1.toCurrencyAbbrev }
        }
        
        return usExchangeRates.map({

            let exchangeAmount = fromCurrency.abbreviation == $0.fromCurrencyAbbrev ? ($0.rate * amount) : ($0.rate * dollarAmount)
            
            return AppManager.config.currencyFactory.createExchangeRate(rate: exchangeAmount.rounded(toPlaces: 2),
                                                                        fromCurAbbr: $0.fromCurrencyAbbrev,
                                                                        toCurAbbr: $0.toCurrencyAbbrev)
        })
    }
}
