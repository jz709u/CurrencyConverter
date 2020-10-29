
import SwiftUI

@available(iOS 13, *)
internal class CurrencyConversionSViewStateModel: ObservableObject {
    
    private let api: CurrencyConversionAPI
    
    init(api: CurrencyConversionAPI = CurrencyLayerAPI()) {
        self.api = api
    }
    
    @Published var availableCurrencies = [Currency]() {
        didSet{
            guard let firstCurrency = availableCurrencies.first else { return }
            fromCurrency = firstCurrency
            for currency in availableCurrencies {
                abbreviationToLocalizedName[currency.abbreviation] = currency.localizedName
            }
        }
    }
    var abbreviationToLocalizedName = [String: String]()
    
    @Published var fromCurrency: Currency = AppManager.config.currencyFactory.createEmptyCurrency() {
        didSet {
            guard isValidAmount() != nil else { return }
            fetchActiveExchangeRates { }
        }
    }
    
    @Published var amount = ""
    @Published var availableExchangeRates = [CurrencyExchangeRate]()
    
    
    var availableCurrenciesCancelable: Cancelable? {
        willSet { availableCurrenciesCancelable?.cancel() }
    }
    var activeRatesCancelable: Cancelable? {
        willSet{ activeRatesCancelable?.cancel() }
    }
    
    func fetchAvailableCurrencies(completion: @escaping () -> Void) {
        availableCurrenciesCancelable = api.getCurrencies { [weak self] (currencies) in
            DispatchQueue.main.async {
                self?.availableCurrencies = currencies
                completion()
            }
        }
    }
    
    func fetchActiveExchangeRates(completion: @escaping () -> Void) {
        guard let amountDouble = isValidAmount() else { completion(); return }
        activeRatesCancelable = api.exchangeRates(fromCurrency: fromCurrency,
                                                  amount: amountDouble,
                                                  completion: { [weak self] (exchangeRates) in
                                                    DispatchQueue.main.async {
                                                        self?.availableExchangeRates = exchangeRates
                                                    }
                                                  })
    }
    
    func isValidAmount() -> Double? {
        guard let decimalValue = Double(amount),
              decimalValue > 0 else {
            return nil
        }
        return decimalValue
    }
}
