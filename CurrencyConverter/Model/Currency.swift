import Foundation

/// Currency 
protocol Currency {

    var abbreviation: String { get }
    var localizedName: String { get }
    var isEmpty: Bool { get }
}

extension Currency {
    var isEmpty: Bool { abbreviation == "-" }
}

/// Currency Exchange Container Object
protocol CurrencyExchangeRates {
    
    var fromCurrencyAbbrev: String { get }
    var exchangeRates: [CurrencyExchangeRate] { get }
}

/// Exchange Rate
protocol CurrencyExchangeRate {
    
    var fromCurrencyAbbrev: String { get }
    var toCurrencyAbbrev: String { get }
    var rate: Double { get }
}

