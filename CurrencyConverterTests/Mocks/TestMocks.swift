@testable import CurrencyConverter
import Foundation

struct MockCurrency: Currency {
    var abbreviation: String
    var localizedName: String
}

struct MockExchangeRatesList: CurrencyExchangeRates {
    var fromCurrencyAbbrev: String
    var exchangeRates: [CurrencyExchangeRate]
}

struct MockExchangeRate: CurrencyExchangeRate {
    var fromCurrencyAbbrev: String
    var toCurrencyAbbrev: String
    var rate: Double
}

class MockDatabase: Database {

    var savedCurrencies = [Currency]()
    func saveIfPossible(currencies: [Currency]) {
        self.savedCurrencies = currencies
    }
    
    var shouldReturnOnGetCurrencies = [Currency]()
    func getCurrencies() -> [Currency] {
        shouldReturnOnGetCurrencies
    }
    
    var savedExchangeRates: CurrencyExchangeRates?
    func saveIfPossible(currencyExchangeRates: CurrencyExchangeRates) {
        savedExchangeRates = currencyExchangeRates
    }
    
    var getExchangeRatesForCurrency: CurrencyExchangeRates?
    func getExchangesRates(for currence: Currency) -> CurrencyExchangeRates? {
        getExchangeRatesForCurrency
    }
    
    var migrateCalled = false
    func migrate() {
        migrateCalled = true
    }
    
    var clearCalled = false
    func clear() {
        clearCalled = true
    }
}

class MockCancelable: Cancelable {
    var cancelCalled = false
    func cancel() {
        cancelCalled = true
    }
}


struct MockAPI: CurrencyConversionAPI {
    
    var shouldReturnCurrenciesOnGet = [Currency]()
    func getCurrencies(completion: @escaping ([Currency]) -> Void) -> Cancelable? {
        completion(shouldReturnCurrenciesOnGet)
        return MockCancelable()
    }
    
    var covertToDouble: Double?
    func convert(fromCurrency: Currency, amount: Double, toCurrency: Currency, completion: @escaping (Double?) -> Void) -> Cancelable? {
        completion(covertToDouble)
        return MockCancelable()
    }
    
    var exchangeRatesFromCurrencyFromAmount = [CurrencyExchangeRate]()
    func exchangeRates(fromCurrency: Currency, amount: Double, completion: @escaping ([CurrencyExchangeRate]) -> Void) -> Cancelable? {
        completion(exchangeRatesFromCurrencyFromAmount)
        return MockCancelable()
    }
    
    var session: CCURLSession
    var database: Database
}

struct MockCCURLSession: CCURLSession {

    var error: Error?
    var bundle: Bundle
    var fixturePathURL: URL
    func dataTaskToDeserialize<T>(object: T.Type, from url: URL, with completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask where T : Decodable {
        
        if let error = error {
            completion(.failure(error))
        } else {
            do {
                let decoder = JSONDecoder()
                let data = try Data(contentsOf: fixturePathURL)
                let decodedObject = try decoder.decode(object, from: data)
                completion(.success(decodedObject))
            } catch {
                
            }
        }
        
        return URLSession.shared.dataTask(with: url)
    }
}
