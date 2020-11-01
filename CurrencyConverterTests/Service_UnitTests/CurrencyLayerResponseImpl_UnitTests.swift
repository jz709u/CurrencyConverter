
import XCTest
@testable import CurrencyConverter

class CurrencyLayerResponseImpl_UnitTests: BaseCurrencyConverterTests {
    
    let jsonDecoder = JSONDecoder()
    /**
     
     {
     "success": true,
     "terms": "https://currencylayer.com/terms",
     "privacy": "https://currencylayer.com/privacy",
     "currencies": {
     "AED": "United Arab Emirates Dirham",
     "AFN": "Afghan Afghani"
     }
     }

     */
    func test_deserialize_SupportedCurrencyLayerResponseImpl() throws {
        
        let result = try jsonDecoder.decode(SupportedCurrencyLayerResponseImpl.self,
                                            from: listAPIJsonData)
        
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.terms, URL(string:"https://currencylayer.com/terms")!)
        XCTAssertEqual(result.privacy, URL(string:"https://currencylayer.com/privacy")!)
        XCTAssertEqual(result.currencies.count, 2)
        
        XCTAssertEqual(result.currencies.first?.abbreviation, "AED")
        XCTAssertEqual(result.currencies.first?.localizedName, "United Arab Emirates Dirham")
        
        XCTAssertEqual(result.currencies[1].abbreviation, "AFN")
        XCTAssertEqual(result.currencies[1].localizedName, "Afghan Afghani")
    }
    
    /**
     {
       "success":true,
       "terms":"https:\/\/currencylayer.com\/terms",
       "privacy":"https:\/\/currencylayer.com\/privacy",
       "timestamp":1603384806,
       "source":"USD",
       "quotes":{
         "USDMOM":3.673009
       }
     }

     */
    func test_deserialize_ActiveCurrencyRatesResponseImpl() throws {
        let result = try jsonDecoder.decode(ActiveCurrencyRatesResponseImpl.self,
                                            from: liveAPIJsonData)
        
        XCTAssertTrue(result.success)
        XCTAssertEqual(result.terms, URL(string:"https://currencylayer.com/terms")!)
        XCTAssertEqual(result.privacy, URL(string:"https://currencylayer.com/privacy")!)
        XCTAssertEqual(result.timestamp, 1603384806)
        XCTAssertEqual(result.source, "USD")
        
        let rates = result.rates
        XCTAssertEqual(rates.fromCurrencyAbbrev, "USD")
        XCTAssertEqual(rates.exchangeRates.count, 1)
        XCTAssertEqual(rates.exchangeRates.first?.fromCurrencyAbbrev, "USD")
        XCTAssertEqual(rates.exchangeRates.first?.toCurrencyAbbrev, "MOM")
        XCTAssertEqual(rates.exchangeRates.first?.rate, 3.673009)
       
    }
}
