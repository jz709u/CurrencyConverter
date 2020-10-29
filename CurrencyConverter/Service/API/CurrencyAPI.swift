import Foundation

protocol CurrencyConversionAPI: BaseAPI {
    
    func getCurrencies(completion: @escaping (_ currencies: [Currency]) -> Void) -> Cancelable?
    
    func convert(fromCurrency: Currency,
                 amount: Double,
                 toCurrency: Currency,
                 completion: @escaping (_ amount: Double?) -> Void) -> Cancelable?
    
    func exchangeRates(fromCurrency: Currency,
                       amount: Double,
                       completion: @escaping (_ exchangeRates: [CurrencyExchangeRate]) -> Void) -> Cancelable?
}
