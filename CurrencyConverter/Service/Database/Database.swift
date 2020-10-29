import Foundation

protocol Database {
    func saveIfPossible(currencies: [Currency])
    func getCurrencies() -> [Currency]
    func saveIfPossible(currencyExchangeRates: CurrencyExchangeRates)
    func getExchangesRates(for currence: Currency) -> CurrencyExchangeRates?
    func migrate()
    func clear()
}

