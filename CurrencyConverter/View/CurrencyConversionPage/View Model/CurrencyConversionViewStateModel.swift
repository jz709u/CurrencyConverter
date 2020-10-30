import Foundation
import SwiftUI

internal class CurrencyConversionViewStateModel {
    
    // MARK: - Observered Properties
    
    var availableCurrencies = [Currency]() {
        didSet{
            guard let firstCurrency = availableCurrencies.first else { return }
            fromCurrency = firstCurrency
            for currency in availableCurrencies {
                abbreviationToLocalizedName[currency.abbreviation] = currency.localizedName
            }
            onAvailableCurrenciesChanged?()
            objectChanged()
        }
    }
    
    var abbreviationToLocalizedName = [String: String]()
    
    var fromCurrency: Currency = AppManager.config.currencyFactory.createEmptyCurrency() {
        didSet {
            guard isValidAmount() != nil else { return }
            fetchActiveExchangeRates { }
            onFromCurrencyChanged?()
            objectChanged()
        }
    }
    
    var amount = "" {
        didSet {
            onAmountChanged?()
            objectChanged()
        }
    }
    
    var availableExchangeRates = [CurrencyExchangeRate]() {
        didSet {
            onAvailableExchangeRatesChanged?()
            objectChanged()
        }
    }
    
    var availableCurrenciesCancelable: Cancelable? {
        willSet { availableCurrenciesCancelable?.cancel() }
    }
    var activeRatesCancelable: Cancelable? {
        willSet{ activeRatesCancelable?.cancel() }
    }
    
    // MARK: - On Change closures
    
    public var onAvailableCurrenciesChanged: (() -> Void)?
    public var onFromCurrencyChanged: (() -> Void)?
    public var onAmountChanged: (() -> Void)?
    public var onAvailableExchangeRatesChanged: (() -> Void)?
    public var onObjectChanged: (() -> Void)?
    
    // MARK: - API
    
    private let api: CurrencyConversionAPI
    
    // MARK: - Life Cycle
    
    init(api: CurrencyConversionAPI = CurrencyLayerAPI()) {
        self.api = api
    }
    
    // MARK: - Fetch Methods
    
    func fetchAvailableCurrencies(completion: @escaping () -> Void) {
        availableCurrenciesCancelable = api.getCurrencies { [weak self] (currencies) in
            DispatchQueue.main.async {
                self?.availableCurrencies = currencies
                completion()
            }
        }
    }
    
    func fetchActiveExchangeRates(completion: @escaping () -> Void) {
        guard let amountDouble = isValidAmount() else { completion(); return }
        activeRatesCancelable = api.exchangeRates(fromCurrency: fromCurrency,
                                                  amount: amountDouble,
                                                  completion: { [weak self] (exchangeRates) in
                                                    DispatchQueue.main.async {
                                                        self?.availableExchangeRates = exchangeRates
                                                    }
                                                  })
    }
    
    // MARK: - validators
    
    func isValidAmount() -> Double? {
        guard let decimalValue = Double(amount),
              decimalValue > 0 else {
            return nil
        }
        return decimalValue
    }
    
    /// SwiftUI update support
    func objectChanged() {
        onObjectChanged?()
        if #available(iOS 14.0,*) {
            objectWillChange.send()
        }
    }
}

@available(iOS 14, *)
extension CurrencyConversionViewStateModel: ObservableObject { }
