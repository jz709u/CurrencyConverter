

import XCTest
import SwiftUI
@testable import CurrencyConverter

class SceneDelegate_UnitTests: BaseCurrencyConverterTests {
    
    @available(iOS 14, *)
    func test_applicationDidFinishLaunching_should_returntrue() {
        
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: .none, options: nil, errorHandler: nil)
        
        let window = UIApplication.shared.windows.first
        
        XCTAssertNotNil(window?.rootViewController as? UIHostingController<NavigationView<CurrencyConversionSView>>)
        
    }
}
