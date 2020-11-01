
import XCTest
@testable import CurrencyConverter

class BaseAPI_UnitTests: BaseCurrencyConverterTests {
    func test_defaultInit() {
        let api = BaseAPIImpl()
        XCTAssertNotNil(api.database as? RealmDatabase)
        XCTAssertEqual(api.session as? URLSession, URLSession.shared)
    }
    
    func test_initWithCustom() {
        let session = MockCCURLSession(bundle: Bundle.main, fixturePathURL: liveAPIJsonFixturePath)
        let otherDB = RealmDatabase()
        let api = BaseAPIImpl(session: session, database: otherDB)
        
        XCTAssertEqual(api.database as? RealmDatabase, otherDB)
        XCTAssertNotNil(api.session as? MockCCURLSession)
    }
}
