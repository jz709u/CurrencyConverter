import Foundation

extension RealmCurrency {
    var currency: Currency {
        set {
            abbreviation = newValue.abbreviation
            localizedName = newValue.localizedName
        }
        get {
            AppManager.config.currencyFactory.createCurrency(abbrev: abbreviation,
                                                             localizedName: localizedName)
        }
    }
}

extension RealmCurrencyExchangeRateList {
    var currencyExchangeRates: CurrencyExchangeRates {
        set {
            fromCurrencyAbbrev = newValue.fromCurrencyAbbrev
            
            let realmRates = newValue.exchangeRates.map ({ (rate) -> RealmCurrencyExchangeRate in
                let realmRate = RealmCurrencyExchangeRate()
                realmRate.currencyExchangeRate = rate
                return realmRate
            })
            
            rates.removeAll()
            rates.append(objectsIn: realmRates)
        }
        get {
            AppManager.config.currencyFactory.createExchangeRates(fromCurAbbr: fromCurrencyAbbrev,
                                                                  rates: rates.map({ $0.currencyExchangeRate }))
        }
    }
}

extension RealmCurrencyExchangeRate {
    var currencyExchangeRate: CurrencyExchangeRate {
        set {
            rate = newValue.rate
            toCurrencyAbbrev = newValue.toCurrencyAbbrev
            fromCurrencyAbbrev = newValue.fromCurrencyAbbrev
        }
        get {
            AppManager.config.currencyFactory.createExchangeRate(rate: rate,
                                                                 fromCurAbbr: fromCurrencyAbbrev,
                                                                 toCurAbbr: toCurrencyAbbrev)
        }
    }
}
