
import XCTest
import UIKit

@testable import CurrencyConverter

class URLSession_CCURLSession_UnitTests: BaseCurrencyConverterTests {
    
    let ccSession: CCURLSession = URLSession.shared
    let catFactURL = URL(string: "https://cat-fact.herokuapp.com/facts")!
    
    struct CatFactList: Decodable {
        var all = [CatFact]()
    }
    
    struct CatFact: Decodable {
        var _id: String
    }
    
    func test_urlSession_shouldFetchListFromURL() {
        let expectation = XCTestExpectation(description: "should deserialize cat list")
        let datatask = ccSession.dataTaskToDeserialize(object: CatFactList.self,
                                        from: catFactURL) { (result) in
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                break
            }
        }
        
        datatask.resume()
        
        wait(for: [expectation], timeout: 3)
    }
}
