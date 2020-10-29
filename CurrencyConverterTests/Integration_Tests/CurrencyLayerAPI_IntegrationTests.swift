
import XCTest
@testable import CurrencyConverter


class CurrencyLayerAPI_IntegrationTests: BaseCurrencyConverterTests {
    
    let testFakeCurrency = MockCurrency(abbreviation: "MOM", localizedName: "Fake Currency")

    override func setUpWithError() throws {
        RealmDatabase().clear()
    }
    
    override func tearDownWithError() throws {
        RealmDatabase().clear()
    }
    
    // MARK: - Test Get Currencies
    
    /**
     "AED": "United Arab Emirates Dirham",
     "AFN": "Afghan Afghani",
     */
    func test_getCurrencies_fromFixture() {
        
        let database = RealmDatabase(expireTime: 10)
        
        let returnedCurrencies = _testCallGetCurrenciesFromAPI(database: database)
        
        _currenciesShouldMatchFixture(currencies: returnedCurrencies)
    }
    
    func test_getCurrencies_shouldFetchFromDB() {
        
        let database = RealmDatabase(expireTime: 10)
        
        database.saveIfPossible(currencies: [testFakeCurrency])
        
        let returnedCurrencies = _testCallGetCurrenciesFromAPI(database: database)
        
        _currenciesShouldMatchFake(currencies: returnedCurrencies)
    }
    
    func test_getCurrencies_shouldExpireInDB() {
        
        let database = RealmDatabase(expireTime: 3)
        let oldCurrenciesInDB = [testFakeCurrency]
        database.saveIfPossible(currencies: oldCurrenciesInDB)
        
        let returnedCurrencies = _testCallGetCurrenciesFromAPI(database: database)
        
        _currenciesShouldMatchFake(currencies: returnedCurrencies)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] () in
            guard let self = self else { return }
            
            let returnedCurrencies = self._testCallGetCurrenciesFromAPI(database: database)
            
            self._currenciesShouldMatchFixture(currencies: returnedCurrencies)
        }
    }
    
    // MARK: - Helper Get Currency
    
    func _testCallGetCurrenciesFromAPI(database: Database) -> [Currency] {
        let mockSession = MockCCURLSession(error: nil,
                                           bundle: bundle,
                                           fixturePathURL: listAPIJsonFixturePath)
        
        let api = CurrencyLayerAPI(session: mockSession,
                                   database: database)
        
        let expectation = XCTestExpectation(description: "expect api to return currencies from DB")
        expectation.expectedFulfillmentCount = 1
        
        var returnedCurrencies = [Currency]()
        
        api.getCurrencies { (currencies) in
            returnedCurrencies = currencies
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        return returnedCurrencies
    }
    
    func _currenciesShouldMatchFake(currencies: [Currency]) {
        XCTAssertEqual(currencies.count, 1)
        XCTAssertEqual(currencies[0].abbreviation, "MOM")
        XCTAssertEqual(currencies[0].localizedName, "Fake Currency")
    }
    
    func _currenciesShouldMatchFixture(currencies: [Currency]) {
        XCTAssertEqual(currencies.count, 2)
        XCTAssertEqual(currencies[0].abbreviation, "AED")
        XCTAssertEqual(currencies[0].localizedName, "United Arab Emirates Dirham")
        
        XCTAssertEqual(currencies[1].abbreviation, "AFN")
        XCTAssertEqual(currencies[1].localizedName, "Afghan Afghani")
    }
    
    // MARK: - Get Exchange Rates
    
    
    func test_getExchangeRates_fromFixture() {
        
        let currencyAmount = 100.0
        
        let database = RealmDatabase(expireTime: 10)
        
        let returnedExchangeRates = _testCallGetExchangeRatesFromAPI(amount: currencyAmount, database: database)
        
        _exchangeRatesShouldEqual(amount: currencyAmount, currencies: returnedExchangeRates)
    }

    func test_getExchangeRates_shouldFetchFromDB() {
        
        let currencyAmount = 100.0

        let database = RealmDatabase(expireTime: 10)

        let fakeExchangeRates = MockExchangeRates(fromCurrencyAbbrev: "USD",
                                                  exchangeRates: [MockExchangeRate(fromCurrencyAbbrev: "USD",
                                                                                   toCurrencyAbbrev: "MOM",
                                                                                   rate: 0.1)])
        
        database.saveIfPossible(currencyExchangeRates: fakeExchangeRates)

        let returnedCurrencies = _testCallGetExchangeRatesFromAPI(amount: currencyAmount,
                                                                  database: database)

        _exchangeRatesShouldEqualFake(amount: currencyAmount,
                                      currencies: returnedCurrencies)
    }

    func test_getExchangeRates_shouldExpireInDB() {

        let currencyAmount = 100.0

        let database = RealmDatabase(expireTime: 3)

        let fakeExchangeRates = MockExchangeRates(fromCurrencyAbbrev: "USD",
                                                  exchangeRates: [MockExchangeRate(fromCurrencyAbbrev: "USD",
                                                                                   toCurrencyAbbrev: "MOM",
                                                                                   rate: 0.1)])
        
        database.saveIfPossible(currencyExchangeRates: fakeExchangeRates)

        let returnedFakeExchangeRates = _testCallGetExchangeRatesFromAPI(amount: currencyAmount,
                                                                  database: database)

        _exchangeRatesShouldEqualFake(amount: currencyAmount,
                                      currencies: returnedFakeExchangeRates)

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] () in
            guard let self = self else { return }

            let returnedExchangeRates = self._testCallGetExchangeRatesFromAPI(amount: currencyAmount,
                                                                              database: database)


            self._exchangeRatesShouldEqual(amount: currencyAmount,
                                           currencies: returnedExchangeRates)
        }
    }
    
    // MARK: - Helper get exchange rates
    
    func _testCallGetExchangeRatesFromAPI(amount: Double, database: Database) -> [CurrencyExchangeRate] {
        let mockSession = MockCCURLSession(error: nil,
                                           bundle: bundle,
                                           fixturePathURL: liveAPIJsonFixturePath)
        
        let api = CurrencyLayerAPI(session: mockSession,
                                   database: database)
        
        let expectation = XCTestExpectation(description: "expect api to return currencies from DB")
        expectation.expectedFulfillmentCount = 1
        
        var returnedExchangeRates = [CurrencyExchangeRate]()
        
        api.exchangeRates(fromCurrency: testFakeCurrency, amount: amount) { (exchangeRates) in
            returnedExchangeRates = exchangeRates
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
        
        return returnedExchangeRates
    }
    
    func _exchangeRatesShouldEqual(amount: Double, currencies: [CurrencyExchangeRate]) {
        XCTAssertEqual(currencies.count, 1)
        XCTAssertEqual(currencies[0].fromCurrencyAbbrev, "MOM")
        XCTAssertEqual(currencies[0].toCurrencyAbbrev, "USD")
        XCTAssertEqual(currencies[0].rate, ((amount / 3.673009) * amount).rounded(toPlaces: 2) )
    }
    
    func _exchangeRatesShouldEqualFake(amount: Double, currencies: [CurrencyExchangeRate]) {
        XCTAssertEqual(currencies.count, 1)
        XCTAssertEqual(currencies[0].fromCurrencyAbbrev, "MOM")
        XCTAssertEqual(currencies[0].toCurrencyAbbrev, "USD")
        XCTAssertEqual(currencies[0].rate, ((amount / 0.1) * amount).rounded(toPlaces: 2) )
    }
   
}
