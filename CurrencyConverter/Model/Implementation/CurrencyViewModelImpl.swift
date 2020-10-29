

struct ViewModelCurrency: Currency {
    let abbreviation: String
    let localizedName: String
}

struct ViewModelCurrencyExchangeRates: CurrencyExchangeRates {
    
    let fromCurrencyAbbrev: String
    let exchangeRates: [CurrencyExchangeRate]
    
    init(fromCurrencyAbbrev: String,
         quotas: [String: Any]) {
        self.fromCurrencyAbbrev = fromCurrencyAbbrev
        exchangeRates = quotas
            .sorted(by: { $0.key < $1.key })
            .map({ ViewModelCurrencyExchangeRate(key: $0, value: $1 as? Double) })
            .compactMap({ $0 })
    }
    
    init(fromCurAbbrev: String,
         exchangeRates: [CurrencyExchangeRate]) {
        self.fromCurrencyAbbrev = fromCurAbbrev
        self.exchangeRates = exchangeRates
    }
}

struct ViewModelCurrencyExchangeRate: CurrencyExchangeRate {
    
    let rate: Double
    let fromCurrencyAbbrev: String
    let toCurrencyAbbrev: String
    
    init?(key: String,
          value: Double?) {
        guard let value = value,
              key.count == 6 else { return nil }
        let middleIndex = key.index(key.startIndex, offsetBy: 3)
        fromCurrencyAbbrev = String(key[key.startIndex..<middleIndex])
        toCurrencyAbbrev = String(key[middleIndex...])
        rate = value
    }
    
    init(rate: Double,
         fromCurAbbrev: String,
         toCurrencyAbbrev: String) {
        self.rate = rate
        self.fromCurrencyAbbrev = fromCurAbbrev
        self.toCurrencyAbbrev = toCurrencyAbbrev
    }
}
