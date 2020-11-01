
import XCTest
@testable import CurrencyConverter

class UIApplicationExtension_UnitTests: BaseCurrencyConverterTests {
    
    func test_rounding() {
        
        let textField = UITextField(frame: .zero)
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {

            textField.becomeFirstResponder()
            XCTAssertTrue(textField.isFirstResponder)
            group.leave()
            
        }
        
        let result = group.wait(timeout: .now() + 1.0)
        switch result {
        case .success, .timedOut:
            
            UIApplication.shared.endEditing()
            XCTAssertFalse(textField.isFirstResponder)
        }
    }
}
