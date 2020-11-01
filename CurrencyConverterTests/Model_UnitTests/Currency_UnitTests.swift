
import XCTest
@testable import CurrencyConverter

class Currency_UnitTests: BaseCurrencyConverterTests {
    
    func test_isEmpty() {
        let currency = MockCurrency(abbreviation: "-", localizedName: "")
        XCTAssertTrue(currency.isEmpty)
    }
}
