

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
        
        let currency = MockCurrency(abbreviation: "1", localizedName: "2")
        
        let realmCurrency = RealmCurrency()
        realmCurrency.currency = currency
        
        XCTAssertEqual(realmCurrency.abbreviation, "1")
        XCTAssertEqual(realmCurrency.localizedName, "2")
    }
    
    // TODO: Add Rest of Adapter Tests
}
