
import XCTest
@testable import CurrencyConverter

class APIable_UnitTests: BaseCurrencyConverterTests {
    
    func test_urlWithSecret() {
        
        enum MockAPI: String, APIable {
           
            var secure: Bool { false }
            var baseURLString: String { "hello.com" }
            var keyAndAccessToken: (key: String, token: String)? { ("key", "token")}
            
            case test
        }
        XCTAssertEqual(MockAPI.test.url?.absoluteString,"http:hello.com/test?key=token")
        
    }
    
    func test_urlSecure() {
        enum MockAPI: String, APIable {
            var keyAndAccessToken: (key: String, token: String)? { nil}
            var secure: Bool { true }
            var baseURLString: String { "hello.com" }
            case test
        }
        
        XCTAssertEqual(MockAPI.test.url?.absoluteString,"https:hello.com/test")
        
    }
    
    func test_urlWithParameters() {
        enum MockAPI: String, APIable {
            var keyAndAccessToken: (key: String, token: String)? { nil}
            var secure: Bool { true }
            var baseURLString: String { "hello.com" }
            case test
        }
        
        XCTAssertEqual(MockAPI.test.url(with: ["1":"2"])?.absoluteString,"https:hello.com/test?1=2")
    }
}
