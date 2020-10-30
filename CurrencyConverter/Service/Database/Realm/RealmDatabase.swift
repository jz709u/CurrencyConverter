import RealmSwift
import Foundation

class RealmDatabase: NSObject, Database {
    
    static let DefaultExpireTime: TimeInterval = 1800
    
    let expireTime: TimeInterval
    
    internal init(expireTime: TimeInterval = RealmDatabase.DefaultExpireTime) {
        self.expireTime = expireTime
    }
    
    func saveIfPossible(currencies: [Currency]) {
        do {
            let realmCurrencies = currencies.map({ (currency) -> RealmCurrency in
                                                    let rCurrency = RealmCurrency()
                                                    rCurrency.currency = currency
                                                    return rCurrency })
            let realm = try Realm()
            try realm.write {
                realm.add(realmCurrencies, update: .modified)
            }
        } catch {
            print("Realm error \(error)")
        }
    }
    
    func getCurrencies() -> [Currency] {
        do {
            let realm = try Realm()
            let rCurrencies = realm.objects(RealmCurrency.self)
            
            guard rCurrencies.first(where: { $0.created.timeIntervalSinceNow > expireTime }) == nil else { return [] }
            
            return Array(rCurrencies
                            .map { $0.currency }
                            .sorted(by: { $0.abbreviation < $1.abbreviation }))
            
        } catch {
            print("Realm error \(error)")
            return []
        }
    }
    
    
    func saveIfPossible(currencyExchangeRates rates: CurrencyExchangeRates) {
        do {
            let realm = try Realm()
            
            let realmRates = RealmCurrencyExchangeRateList()
            realmRates.currencyExchangeRates = rates

            try realm.write {
                realm.add(realmRates, update: .modified)
            }
            
        } catch {
            print("Realm error \(error)")
        }
    }
    
    func getExchangesRates(for currency: Currency) -> CurrencyExchangeRates? {
        do {
            let now = Date()
            let realm = try Realm()
            let realmCurrencyExchangeRates = realm.objects(RealmCurrencyExchangeRateList.self)
                .filter("fromCurrencyAbbrev = '\(currency.abbreviation)'")
            
            guard realmCurrencyExchangeRates.first(where: { $0.created.timeIntervalSinceNow > expireTime }) == nil else { return nil }
            
            return realmCurrencyExchangeRates.map({ $0.currencyExchangeRates }).first
            
        } catch {
            print("Realm error \(error)")
            return nil
        }
    }
    
    func migrate() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    func clear() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("clear issues")
        }
    }
}
