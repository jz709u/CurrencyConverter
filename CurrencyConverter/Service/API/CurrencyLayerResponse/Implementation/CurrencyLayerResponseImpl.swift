
import Foundation

struct ConvertCurrencyLayerResponseImpl: ConvertCurrencyLayerResponse {
    var timestamp: TimeInterval
    var result: Double
    var success: Bool
    var terms: URL
    var privacy: URL
}

struct SupportedCurrencyLayerResponseImpl: SupportedCurrencyLayerResponse {
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case currencies
        case success
        case terms
        case privacy
    }
    
    // MARK: - Variables
    var currencies: [Currency]
    var success: Bool
    var terms: URL
    var privacy: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        currencies = (try? container.decode([String: String].self,
                                            forKey: .currencies))?
            .sorted { $0.key < $1.key }
            .map({ AppManager.config.currencyFactory.createCurrency(abbrev: $0,
                                                                    localizedName: $1) }) ?? [Currency]()
        success = try container.decode(Bool.self,
                                       forKey: .success)
        terms = try container.decode(URL.self,
                                     forKey: .terms)
        privacy = try container.decode(URL.self,
                                       forKey: .privacy)
    }
}

struct ActiveCurrencyRatesResponseImpl: ActiveCurrencyRatesResponse {
    
    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case rates = "quotes"
        case timestamp
        case success
        case terms
        case privacy
        case source
    }

    var rates: CurrencyExchangeRates
    var timestamp: TimeInterval
    var success: Bool
    var terms: URL
    var privacy: URL
    var source: String
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        timestamp = try container.decode(Double.self,
                                         forKey: .timestamp)
        source = try container.decode(String.self,
                                      forKey: .source)
        
        success = try container.decode(Bool.self,
                                       forKey: .success)
        terms = try container.decode(URL.self,
                                     forKey: .terms)
        privacy = try container.decode(URL.self,
                                       forKey: .privacy)
        
        let _quotas = (try? container.decode([String:Any].self,
                                             forKey: .rates)) ?? [String:Any]()
        rates = AppManager.config.currencyFactory.createExchangeRates(fromCurAbbr: source,
                                                                       quotas: _quotas)

    }
}

