
import XCTest
import RealmSwift
@testable import CurrencyConverter

class RealmDatabase_UnitTests: BaseCurrencyConverterTests {
    
    var realmDatabase = RealmDatabase()
    
    // MARK: - Life Cycle

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        realmDatabase = RealmDatabase()
        realmDatabase.clear()
    }
    
    // MARK: - Test Get Currencies
    
    func test_shouldReturnNoCurrencies_forEmptyDB() {
        XCTAssertEqual(realmDatabase.getCurrencies().count, 0)
    }
    
    let testCurrency = MockCurrency(abbreviation: "hello", localizedName: "world")
    
    func test_shouldGetCurrencies_ifExists() throws {
        
        _addTestCurrencyToRealmDB()
        
        let result = realmDatabase.getCurrencies().filter({
            $0.abbreviation == testCurrency.abbreviation &&
            $0.localizedName == testCurrency.localizedName
        })
        
        _testShouldContainMock(result: result)
    }
    
    func test_shouldNotGetCurrencies_ifExpireTimePasses() throws {
        
        realmDatabase = RealmDatabase(expireTime: 10)
        
        _addTestCurrencyToRealmDB()
        
        let results = realmDatabase.getCurrencies()
        
        _testShouldContainMock(result: results)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
            let resultsAfter10 = self.realmDatabase.getCurrencies()
            XCTAssertEqual(resultsAfter10.count, 0)
        }
    }
    
    // MARK: - Test Save Currencies
    
    func test_shouldSaveCurrencies() throws {
    
        _addTestCurrencyToRealmDB()
        
        let realm = try Realm()
        let foundMock = realm.objects(RealmCurrency.self).first(where: { $0.abbreviation == testCurrency.abbreviation &&
                                                                    $0.localizedName == testCurrency.localizedName })
       
        XCTAssertNotNil(foundMock)
    }
    
    func test_shouldSave2Currencies_withDifferentAbbreviations() throws {
    
        _addTestCurrencyToRealmDB()
        
        realmDatabase.saveIfPossible(currencies: [MockCurrency(abbreviation: "hello2", localizedName: "world2")])
        
        let realm = try Realm()
       
        XCTAssertEqual(realm.objects(RealmCurrency.self).count,2)
    }
    
    func test_shouldReplaceCurrencies_withSameAbbreviations() throws {
    
        _addTestCurrencyToRealmDB()
        
        realmDatabase.saveIfPossible(currencies: [MockCurrency(abbreviation: "hello", localizedName: "world2")])
        
        let realm = try Realm()
       
        let currencies = realm.objects(RealmCurrency.self)
        
        XCTAssertEqual(currencies.count,1)
        XCTAssertEqual(currencies.first?.localizedName,"world2")
    }
    
    func _testShouldContainMock(result: [Currency]) {
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.abbreviation, testCurrency.abbreviation)
        XCTAssertEqual(result.first?.localizedName, testCurrency.localizedName)
    }
    
    func _addTestCurrencyToRealmDB() {
        realmDatabase.saveIfPossible(currencies: [testCurrency])
    }
    
    // MARK: - Get Exchange Rates
    
    let testSubRates = [MockExchangeRate(fromCurrencyAbbrev: "hello_sub", toCurrencyAbbrev: "world_sub", rate: 10)]
    var testRates: MockExchangeRatesList { MockExchangeRatesList(fromCurrencyAbbrev: "hello", exchangeRates: testSubRates) }
    
    func test_shouldGetExchangeRates() throws {
        
        realmDatabase.saveIfPossible(currencyExchangeRates: testRates)
        
        let rates = realmDatabase.getExchangesRates(for: testCurrency)
       
        XCTAssertNotNil(rates)
    }
    
    func test_shouldNotGetExchangeRates_ifEmpty() {
        
        let rates = realmDatabase.getExchangesRates(for: testCurrency)
        
        XCTAssertNil(rates)
    }
    
    func test_shouldNotGetExchangeRates_ifExpireTimePasses() throws {
        
        realmDatabase = RealmDatabase(expireTime: 10)
        
        realmDatabase.saveIfPossible(currencyExchangeRates: testRates)
        
        let rates = realmDatabase.getExchangesRates(for: testCurrency)
        
        XCTAssertNotNil(rates)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 11) {
            let resultsAfter10 = self.realmDatabase.getExchangesRates(for: self.testCurrency)
            XCTAssertNotNil(resultsAfter10)
        }
    }
    
    // MARK: - Test Save Exchange Rates
    
    func test_shouldSaveExchangeRates_validateData() throws {
        
        realmDatabase.saveIfPossible(currencyExchangeRates: testRates)
        
        let realm = try Realm()
        let foundMock = realm.objects(RealmCurrencyExchangeRateList.self).first { (realmRate) -> Bool in
            realmRate.fromCurrencyAbbrev == testRates.fromCurrencyAbbrev &&
                 realmRate.rates.count == 1 &&
            realmRate.rates.first?.fromCurrencyAbbrev == testSubRates.first?.fromCurrencyAbbrev &&
                realmRate.rates.first?.toCurrencyAbbrev == testSubRates.first?.toCurrencyAbbrev &&
                realmRate.rates.first?.rate == testSubRates.first?.rate
        }
       
        XCTAssertNotNil(foundMock)
    }
    
    func test_shouldSaveExchangeRates_withDifferentAbbreviations() throws {
    
        realmDatabase.saveIfPossible(currencyExchangeRates: testRates)
        
        var testRates2 = testRates
        testRates2.fromCurrencyAbbrev = "hello2"
        realmDatabase.saveIfPossible(currencyExchangeRates: testRates2)
        
        
        let realm = try Realm()
       
        XCTAssertEqual(realm.objects(RealmCurrencyExchangeRateList.self).count,2)
    }
    
    func test_shouldReplaceExchangeRates_withSameAbbreviations() throws {
    
        realmDatabase.saveIfPossible(currencyExchangeRates: testRates)
        
        var testRates2 = testRates
        testRates2.exchangeRates = [MockExchangeRate(fromCurrencyAbbrev: "2", toCurrencyAbbrev: "2", rate: 10)]
        realmDatabase.saveIfPossible(currencyExchangeRates: testRates2)
        
        let realm = try Realm()
       
        let exchangeRatesInRealm = realm.objects(RealmCurrencyExchangeRateList.self)
    
        XCTAssertEqual(exchangeRatesInRealm.count,1)
        
        let rates = exchangeRatesInRealm.first?.rates

        XCTAssertEqual(rates?.count,1)
        XCTAssertEqual(rates?.first?.fromCurrencyAbbrev,"2")
        XCTAssertEqual(rates?.first?.toCurrencyAbbrev,"2")
        XCTAssertEqual(rates?.first?.rate,10)
    }
    
    // MARK: - Test Clear
    
    func test_clear() {
        realmDatabase.saveIfPossible(currencies: [testCurrency])
        realmDatabase.saveIfPossible(currencyExchangeRates: testRates)
        
        XCTAssertEqual(realmDatabase.getCurrencies().count, 1)
        XCTAssertNotNil(realmDatabase.getExchangesRates(for: testCurrency))
        
        realmDatabase.clear()
        
        XCTAssertEqual(realmDatabase.getCurrencies().count, 0)
        XCTAssertNil(realmDatabase.getExchangesRates(for: testCurrency))
    }
}
