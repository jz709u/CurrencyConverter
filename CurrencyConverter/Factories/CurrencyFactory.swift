import Foundation

protocol CurrencyFactory {
    func createEmptyCurrency() -> Currency
    func usDollarCurrency() -> Currency
    func createCurrency(abbrev: String, localizedName: String) -> Currency
    func createExchangeRates(fromCurAbbr: String, quotas: [String: Any]) -> CurrencyExchangeRates
    func createExchangeRates(fromCurAbbr: String, rates: [CurrencyExchangeRate]) -> CurrencyExchangeRates
    func createExchangeRate(rate: Double, fromCurAbbr: String, toCurAbbr: String) -> CurrencyExchangeRate
}

struct DefaultCurrencyFactory: CurrencyFactory {
    
    func createEmptyCurrency() -> Currency { ViewModelCurrency(abbreviation: "-",
                                                               localizedName: "") }
    func usDollarCurrency() -> Currency { ViewModelCurrency(abbreviation: AppConstants.ISO4217_USD,
                                                            localizedName: "") }
    
    func createCurrency(abbrev: String, localizedName: String) -> Currency {
        ViewModelCurrency(abbreviation: abbrev,
                          localizedName: localizedName)
    }
    
    func createExchangeRates(fromCurAbbr: String, quotas: [String: Any]) -> CurrencyExchangeRates {
        ViewModelCurrencyExchangeRates(fromCurrencyAbbrev: fromCurAbbr,
                                       quotas: quotas)
    }
    
    func createExchangeRates(fromCurAbbr: String, rates: [CurrencyExchangeRate]) -> CurrencyExchangeRates {
        ViewModelCurrencyExchangeRates(fromCurAbbrev: fromCurAbbr,
                                       exchangeRates: rates)
    }
    
    func createExchangeRate(rate: Double, fromCurAbbr: String, toCurAbbr: String) -> CurrencyExchangeRate {
        ViewModelCurrencyExchangeRate(rate: rate,
                                      fromCurAbbrev: fromCurAbbr,
                                      toCurrencyAbbrev: toCurAbbr)
    }
}
