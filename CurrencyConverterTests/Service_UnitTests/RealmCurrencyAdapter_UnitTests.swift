

import XCTest
import RealmSwift
@testable import CurrencyConverter

class RealmCurrencyAdapter_UnitTests: BaseCurrencyConverterTests {
    
    // MARK: - Test RealmCurrency to Currency
    
    func test_realmCurrency_to_currency() {
        
        let realmCurrency = RealmCurrency()
        realmCurrency.abbreviation = "1"
        realmCurrency.localizedName = "2"
        
        let currency = realmCurrency.currency
        
        XCTAssertEqual(currency.abbreviation, "1")
        XCTAssertEqual(currency.localizedName, "2")
    }
    
    func test_currency_to_RealmCurrency() {
        
        let currency = MockCurrency(abbreviation: "1",
                                    localizedName: "2")
        
        let realmCurrency = RealmCurrency()
        realmCurrency.currency = currency
        
        XCTAssertEqual(realmCurrency.abbreviation, "1")
        XCTAssertEqual(realmCurrency.localizedName, "2")
    }
    
    // MARK: - test conversion Exchange Rate List
    
    func test_realmExchangeRateList_to_exchangeRateList() {
        
        
        let realmExchangeRateList = RealmCurrencyExchangeRateList()
        realmExchangeRateList.fromCurrencyAbbrev = "1"
        
        let realmRate = RealmCurrencyExchangeRate()
        realmRate.fromCurrencyAbbrev = "2"
        realmRate.toCurrencyAbbrev = "3"
        realmRate.rate = 0.5
        
        realmExchangeRateList.rates.append(realmRate)
        
        
        let currency = realmExchangeRateList.currencyExchangeRates
        
        XCTAssertEqual(currency.fromCurrencyAbbrev, "1")
        XCTAssertEqual(currency.exchangeRates.count, 1)
        XCTAssertEqual(currency.exchangeRates.first?.fromCurrencyAbbrev, "2")
        XCTAssertEqual(currency.exchangeRates.first?.toCurrencyAbbrev, "3")
        XCTAssertEqual(currency.exchangeRates.first?.rate, 0.5)
        
    }
    
    func test_exchangeRateList_to_realmExchangeRateList()  {
        
        let ratesList = MockExchangeRatesList(fromCurrencyAbbrev: "1",
                                              exchangeRates: [MockExchangeRate(fromCurrencyAbbrev: "2",
                                                                               toCurrencyAbbrev: "3",
                                                                               rate: 0.5)])
        
        // should reflect mock
        
        let realmRateList = RealmCurrencyExchangeRateList()
        realmRateList.currencyExchangeRates = ratesList
        
        XCTAssertEqual(realmRateList.fromCurrencyAbbrev, "1")
        XCTAssertEqual(realmRateList.rates.count, 1)
        XCTAssertEqual(realmRateList.rates.first?.fromCurrencyAbbrev, "2")
        XCTAssertEqual(realmRateList.rates.first?.toCurrencyAbbrev, "3")
        XCTAssertEqual(realmRateList.rates.first?.rate, 0.5)
    }
    
    // MARK: - test created Exchange rate
    
    func test_realmExchangeRate_to_exchangeRate() {
        
        let realmRate = RealmCurrencyExchangeRate()
        realmRate.fromCurrencyAbbrev = "2"
        realmRate.toCurrencyAbbrev = "3"
        realmRate.rate = 0.5
        
        
        let currencyRate = realmRate.currencyExchangeRate
   
        XCTAssertEqual(currencyRate.fromCurrencyAbbrev, "2")
        XCTAssertEqual(currencyRate.toCurrencyAbbrev, "3")
        XCTAssertEqual(currencyRate.rate, 0.5)
        
    }
    
    func test_exchangeRate_to_realmExchangeRate()  {
        
        let mockRate = MockExchangeRate(fromCurrencyAbbrev: "2",
                                        toCurrencyAbbrev: "3",
                                        rate: 0.5)
        
        // should reflect mock
        
        let realmRate = RealmCurrencyExchangeRate()
        realmRate.currencyExchangeRate = mockRate
        
        XCTAssertEqual(realmRate.fromCurrencyAbbrev, "2")
        XCTAssertEqual(realmRate.toCurrencyAbbrev, "3")
        XCTAssertEqual(realmRate.rate, 0.5)
    }
}
