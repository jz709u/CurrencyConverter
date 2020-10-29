import Foundation

class AppManager {
    static let config: AppConfig = DefaultAppConfig()
}

protocol AppConfig {
    var database: Database { get }
    var currencyFactory: CurrencyFactory { get }
}

class DefaultAppConfig: AppConfig {
    let thirtyMinutes: TimeInterval = { 30 * 60 }()
    lazy var database: Database = { RealmDatabase(expireTime: self.thirtyMinutes) }()
    let currencyFactory: CurrencyFactory = DefaultCurrencyFactory()
}

