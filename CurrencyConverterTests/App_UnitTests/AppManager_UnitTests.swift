
import XCTest
@testable import CurrencyConverter

class AppManager_UnitTests: BaseCurrencyConverterTests {
    
    func test_defaults() {
        XCTAssertNotNil(AppManager.config as? DefaultAppConfig)
    }
    
    func test_defaultConig_currencyFactory() {
        guard let config = AppManager.config as? DefaultAppConfig else { return }
        
        XCTAssertNotNil(config.currencyFactory as? DefaultCurrencyFactory)
    }
    
    func test_defaultConig_minutes() {
        guard let config = AppManager.config as? DefaultAppConfig else { return }
        
        XCTAssertEqual(config.thirtyMinutes,1800)
    }
    
    func test_defaultConig_defaultDB_realm() {
        guard let config = AppManager.config as? DefaultAppConfig else { return }
        
        XCTAssertNotNil(config.database as? RealmDatabase)
    }
}
