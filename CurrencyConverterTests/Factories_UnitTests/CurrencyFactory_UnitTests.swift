import XCTest
@testable import CurrencyConverter

class DefaultCurrencyFactory_UnitTests: BaseCurrencyConverterTests {

    var defaultCurrencyFactory = DefaultCurrencyFactory()
    
    override func setUp() {
        super.setUp()
        defaultCurrencyFactory = DefaultCurrencyFactory()
    }
    
    func test_createEmptyCurrency() {
        let emptyCurrency = defaultCurrencyFactory.createEmptyCurrency()
        
        XCTAssertEqual(emptyCurrency.abbreviation, "-")
        XCTAssertEqual(emptyCurrency.localizedName, "")
    }
    
    func test_createUSDollarCurrency() {
        let dollarCurrency = defaultCurrencyFactory.usDollarCurrency()
        
        XCTAssertEqual(dollarCurrency.abbreviation, AppConstants.ISO4217_USD)
        XCTAssertEqual(dollarCurrency.localizedName, "")
    }
    
    func test_createCurrency_withAbbrevAndLocalizedName() {
        let currency = defaultCurrencyFactory.createCurrency(abbrev: "1", localizedName: "2")
        XCTAssertEqual(currency.abbreviation, "1")
        XCTAssertEqual(currency.localizedName, "2")
    }
    
    func test_createExchangeRates_withCurAbbreb_and_quotes() {
        let exchangeRates = defaultCurrencyFactory.createExchangeRates(fromCurAbbr: "1",
                                                                       quotas: ["fesyyy":123.223])
        XCTAssertEqual(exchangeRates.fromCurrencyAbbrev, "1")
        XCTAssertEqual(exchangeRates.exchangeRates.count, 1)
        XCTAssertEqual(exchangeRates.exchangeRates.first?.fromCurrencyAbbrev, "fes")
        XCTAssertEqual(exchangeRates.exchangeRates.first?.toCurrencyAbbrev, "yyy")
        XCTAssertEqual(exchangeRates.exchangeRates.first?.rate, 123.223)
    }
    
    func test_createExchangeRates_withCurAbbreb_and_invalidQuotes() {
        let exchangeRates = defaultCurrencyFactory.createExchangeRates(fromCurAbbr: "1",
                                                                       quotas: ["fesyyy":"123.223"])
        XCTAssertEqual(exchangeRates.fromCurrencyAbbrev, "1")
        XCTAssertEqual(exchangeRates.exchangeRates.count, 0)
    }
    
    func test_createExchangeRates_withCurAbbreb_and_emptyQuotes() {
        let exchangeRates = defaultCurrencyFactory.createExchangeRates(fromCurAbbr: "1",
                                                                       quotas: [:])
        XCTAssertEqual(exchangeRates.fromCurrencyAbbrev, "1")
        XCTAssertEqual(exchangeRates.exchangeRates.count, 0)
    }
    
    func test_createExchangeRates_withCurAbbreb_withExchangeRates() {
        
        
        let exchangeRates = defaultCurrencyFactory.createExchangeRates(fromCurAbbr: "1", rates: [
            MockExchangeRate(fromCurrencyAbbrev: "1", toCurrencyAbbrev: "2", rate: 1.2)
        ])
        XCTAssertEqual(exchangeRates.fromCurrencyAbbrev, "1")
        XCTAssertEqual(exchangeRates.exchangeRates.count, 1)
        XCTAssertEqual(exchangeRates.exchangeRates.first?.fromCurrencyAbbrev, "1")
        XCTAssertEqual(exchangeRates.exchangeRates.first?.toCurrencyAbbrev, "2")
        XCTAssertEqual(exchangeRates.exchangeRates.first?.rate, 1.2)
    }
    
    func test_createExchangeRate() {
        let exchangeRate = defaultCurrencyFactory.createExchangeRate(rate: 1.2, fromCurAbbr: "1", toCurAbbr: "2")
        
        XCTAssertEqual(exchangeRate.fromCurrencyAbbrev, "1")
        XCTAssertEqual(exchangeRate.toCurrencyAbbrev, "2")
        XCTAssertEqual(exchangeRate.rate, 1.2)
    }
}
