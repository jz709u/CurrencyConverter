import Foundation
import RealmSwift

// MARK: - RealmCurrency

/// Realm Currency Object
class RealmCurrency: Object {
    
    // MARK: - Realm
    
    override class func primaryKey() -> String? { "abbreviation" }
    
    @objc dynamic var created: Date = Date()
    @objc dynamic var abbreviation: String = ""
    @objc dynamic var localizedName: String = ""

}

// MARK: - RealmCurrencyExchangeRates

/// Realm Currency Object
class RealmCurrencyExchangeRateList: Object {
    
    // MARK: - Realm
    
    override class func primaryKey() -> String? { "fromCurrencyAbbrev" }
    
    @objc dynamic var created: Date = Date()
    @objc dynamic var fromCurrencyAbbrev: String = ""
    let rates = List<RealmCurrencyExchangeRate>()

}

// MARK: - RealmCurrencyExchangeRate

/// Realm Currency Exchange Rate
class RealmCurrencyExchangeRate: Object {
    
    // MARK: - Realm
    
    @objc dynamic var created: Date = Date()
    @objc dynamic var fromCurrencyAbbrev: String = ""
    @objc dynamic var toCurrencyAbbrev: String = ""
    @objc dynamic var rate: Double = 0.0

}
