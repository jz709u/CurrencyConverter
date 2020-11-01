
import XCTest
@testable import CurrencyConverter

class DoubleRounding_UnitTests: BaseCurrencyConverterTests {
    
    func test_rounding() {
        let testNumber = 0.123
        
        let roundedNumber = testNumber.rounded(toPlaces: 1)
        
        XCTAssertEqual(roundedNumber, 0.1)
    }
    
    func test_roundToZeroPlaces() {
        let testNumber = 0.123
        
        let roundedNumber = testNumber.rounded(toPlaces: 0)
        
        XCTAssertEqual(roundedNumber, 0)
    }
    
    func test_roundingNonExistentPlace() {
        let testNumber = 0.123
        
        let roundedNumber = testNumber.rounded(toPlaces: 5)
        
        XCTAssertEqual(roundedNumber, 0.123)
    }
}
