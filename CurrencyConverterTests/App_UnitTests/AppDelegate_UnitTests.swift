
import XCTest
@testable import CurrencyConverter

class AppDelegate_UnitTests: BaseCurrencyConverterTests {
    
    func test_applicationDidFinishLaunching_should_returntrue() {
        let delegate = AppDelegate()
        XCTAssertTrue(delegate.application(UIApplication.shared,
                             didFinishLaunchingWithOptions: nil))
        
    }
    
    @available(iOS 14.0, *)
    func test_applicationDidFinishLaunching_iOS14_window_shouldBeNil() {
        let delegate = AppDelegate()
        _ = delegate.application(UIApplication.shared,
                                 didFinishLaunchingWithOptions: nil)
        XCTAssertNil(delegate.window)
    }
    
    func test_applicationDidFinishLaunching_iOS14isNotAvailable_window_shouldBeInitialized() {
        if #available(iOS 14, *) { return }
        let delegate = AppDelegate()
        _ = delegate.application(UIApplication.shared,
                                 didFinishLaunchingWithOptions: nil)
        
        XCTAssertNotNil(delegate.window?.rootViewController as? CurrencyConversionViewController)
    }
}
