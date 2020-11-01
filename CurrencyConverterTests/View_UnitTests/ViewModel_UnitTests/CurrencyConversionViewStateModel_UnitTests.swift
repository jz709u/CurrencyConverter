

import XCTest
@testable import CurrencyConverter

class CurrencyConversionViewStateModel_UnitTests: BaseCurrencyConverterTests {
    var model = CurrencyConversionViewStateModel()
    let session = MockCCURLSession(error: nil, bundle: Bundle.main, fixturePathURL: URL(string:"dummy")!)
    var mockAPI: MockAPI!
    let db = MockDatabase()
    
    override func setUp() {
        mockAPI =  MockAPI(session: session, database: db)
    }
    
    // MARK: - Fetch Currencies
    
    func test_fetchCurrencies() {
        
        mockAPI.shouldReturnCurrenciesOnGet = [MockCurrency(abbreviation: "1", localizedName: "2")]
        
        model = CurrencyConversionViewStateModel(api: mockAPI)
        model.fetchAvailableCurrencies {
            XCTAssertEqual(self.model.availableCurrencies.count, 1)
            XCTAssertEqual(self.model.availableCurrencies.first?.abbreviation, "1")
            XCTAssertEqual(self.model.availableCurrencies.first?.localizedName, "2")
        }
    }
    
    func test_fetchCurrencies_shouldSetFromCurrencyWithDefaultValue() {
        
        mockAPI.shouldReturnCurrenciesOnGet = [MockCurrency(abbreviation: "1", localizedName: "2")]
        
        model = CurrencyConversionViewStateModel(api: mockAPI)
        model.fetchAvailableCurrencies {
            XCTAssertFalse(self.model.fromCurrency.isEmpty)
            
            XCTAssertEqual(self.model.fromCurrency.abbreviation, "1")
            XCTAssertEqual(self.model.fromCurrency.localizedName, "2")
        }
    }
    
    func test_fetchCurrencies_shouldSetLocalizationMap() {
        
        mockAPI.shouldReturnCurrenciesOnGet = [MockCurrency(abbreviation: "1", localizedName: "2")]
        
        model = CurrencyConversionViewStateModel(api: mockAPI)
        model.fetchAvailableCurrencies {
            
            XCTAssertEqual(self.model.abbreviationToLocalizedName["1"], "2")
        }
    }
    
    func test_fetchCurrencies_currencies_onAvailableCurrenciesChanged_onObjectChanged_ShouldBeCalled() {
        
        mockAPI.shouldReturnCurrenciesOnGet = [MockCurrency(abbreviation: "1", localizedName: "2")]
        
        model = CurrencyConversionViewStateModel(api: mockAPI)
        
        
        let expectation = XCTestExpectation(description: "on set")
        expectation.expectedFulfillmentCount = 2
        model.onAvailableCurrenciesChanged = {
            expectation.fulfill()
        }
        
        model.onObjectChanged = {
            expectation.fulfill()
        }
        
        model.fetchAvailableCurrencies { }
        
        wait(for: [expectation], timeout: 3)
    }
    
    // MARK: - Fetch Exchange Rates
    
    func test_fetchExchangeRates_withEmptyAmount() {
        
        mockAPI.exchangeRatesFromCurrencyFromAmount = [MockExchangeRate(fromCurrencyAbbrev: "1", toCurrencyAbbrev: "2", rate: 1.0)]
        model = CurrencyConversionViewStateModel(api: mockAPI)
        
        model.amount = ""
        model.fetchActiveExchangeRates {
            XCTAssertEqual(self.model.availableExchangeRates.count, 0)
        }
    }
    
    func test_fetchExchangeRates_callEventHandlers() {
        
        mockAPI.exchangeRatesFromCurrencyFromAmount = [MockExchangeRate(fromCurrencyAbbrev: "1", toCurrencyAbbrev: "2", rate: 1.0)]
        
        model = CurrencyConversionViewStateModel(api: mockAPI)
        model.amount = "1.23"
        
        let expectation = XCTestExpectation(description: "changed")
        model.onAvailableExchangeRatesChanged = {
            expectation.fulfill()
        }
        model.onObjectChanged = {
            expectation.fulfill()
        }
        
        model.fetchActiveExchangeRates {
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_fetchExchangeRates_withValidAmount() {
        
        mockAPI.exchangeRatesFromCurrencyFromAmount = [MockExchangeRate(fromCurrencyAbbrev: "1", toCurrencyAbbrev: "2", rate: 1.0)]
        model = CurrencyConversionViewStateModel(api: mockAPI)
        
        model.amount = "1.23"
        model.fetchActiveExchangeRates {
            
            XCTAssertEqual(self.model.availableExchangeRates.count, 1)
            XCTAssertEqual(self.model.availableExchangeRates.first?.fromCurrencyAbbrev, "1")
            XCTAssertEqual(self.model.availableExchangeRates.first?.toCurrencyAbbrev, "2")
            XCTAssertEqual(self.model.availableExchangeRates.first?.rate, 1.0)
        }
    }
    
    func test_isValidAmount() {
        
        model = CurrencyConversionViewStateModel(api: mockAPI)

        model.amount = "1.23"
        XCTAssertNotNil(model.isValidAmount())
    }
    
    func test_onAmountChanged_shouldTriggerClosures() {
        
        mockAPI.exchangeRatesFromCurrencyFromAmount = [MockExchangeRate(fromCurrencyAbbrev: "1", toCurrencyAbbrev: "2", rate: 1.0)]
        model = CurrencyConversionViewStateModel(api: mockAPI)
    
        let expectation = XCTestExpectation(description: "expectation object changed")
        expectation.expectedFulfillmentCount = 2
        
        model.onAmountChanged = {
            expectation.fulfill()
        }
        
        model.onObjectChanged = {
            expectation.fulfill()
        }
        
        model.amount = "23232.23"
        
        wait(for: [expectation], timeout: 2)
    }
}
