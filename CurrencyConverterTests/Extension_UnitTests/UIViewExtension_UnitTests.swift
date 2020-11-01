
import XCTest
@testable import CurrencyConverter

class UIViewExtension_UnitTests: BaseCurrencyConverterTests {
    
    func test_fillingView() {
        
        let theView = UIView(frame: .zero)
        let otherView = UIView(frame: .init(origin: .zero, size: CGSize(width: 10, height: 10)))
        
        theView.fill(view: otherView)
        
        otherView.setNeedsLayout()
        otherView.layoutIfNeeded()
        
        XCTAssertEqual(otherView.frame, theView.frame)
    
    }
}
