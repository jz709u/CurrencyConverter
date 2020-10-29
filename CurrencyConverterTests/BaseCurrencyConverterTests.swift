import XCTest
@testable import CurrencyConverter

class BaseCurrencyConverterTests: XCTestCase {
    
    lazy var bundle: Bundle = {
        Bundle(for: type(of: self))
    }()
    
    lazy var liveAPIJsonData: Data = {
        try! Data(contentsOf: self.liveAPIJsonFixturePath)
    }()
    
    lazy var liveAPIJsonFixturePath: URL = {
        self.bundle.url(forResource: "api.CurrencyLayer.live", withExtension: "json")!
    }()
    
    lazy var listAPIJsonData: Data = {
        try! Data(contentsOf: self.listAPIJsonFixturePath)
    }()
    
    lazy var listAPIJsonFixturePath: URL = {
        self.bundle.url(forResource: "api.CurrencyLayer.list", withExtension: "json")!
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("\(liveAPIJsonData) \(listAPIJsonData)")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}
