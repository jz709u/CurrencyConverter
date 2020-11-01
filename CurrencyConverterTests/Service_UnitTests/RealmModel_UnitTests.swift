import XCTest
import RealmSwift
@testable import CurrencyConverter

class RealmModel_UnitTests: BaseCurrencyConverterTests {
    func test_realmCurrency_defaultValues() {
        let currency = RealmCurrency()
        
        let shouldBeVerySmall = currency.created.distance(to: Date())
        XCTAssertTrue(shouldBeVerySmall < 0.001)
        XCTAssertEqual(currency.abbreviation,"")
        XCTAssertEqual(currency.localizedName,"")
        XCTAssertEqual(RealmCurrency.primaryKey(), "abbreviation")
    }
    
    func test_realmExchangeRatesList_defualtValues() {
        let exchangeRateList  = RealmCurrencyExchangeRateList()
        
        let shouldBeVerySmall = exchangeRateList.created.distance(to: Date())
        XCTAssertTrue(shouldBeVerySmall < 0.001)
        XCTAssertEqual(exchangeRateList.fromCurrencyAbbrev,"")
        XCTAssertEqual(exchangeRateList.rates.count,0)
        XCTAssertEqual(RealmCurrencyExchangeRateList.primaryKey(), "fromCurrencyAbbrev")
    }
    
    func test_realmExchangeRate_defaultValues() {
        let rate = RealmCurrencyExchangeRate()
        
        let shouldBeVerySmall = rate.created.distance(to: Date())
        XCTAssertTrue(shouldBeVerySmall < 0.001)
        XCTAssertEqual(rate.fromCurrencyAbbrev,"")
        XCTAssertEqual(rate.toCurrencyAbbrev,"")
        XCTAssertEqual(rate.rate,0.0)
    }
}
