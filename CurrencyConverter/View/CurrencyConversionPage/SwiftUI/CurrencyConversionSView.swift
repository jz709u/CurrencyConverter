
import SwiftUI

@available(iOS 14, *)
struct CurrencyConversionSView: View {
    
    @State private var initialized = false
    
    @ObservedObject private var viewModel: CurrencyConversionSViewStateModel
    
    init(viewModel: CurrencyConversionSViewStateModel = CurrencyConversionSViewStateModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        InitializingSView(initialized: initialized) {
            VStack {
                Form {
                    ConvertFromSectionSUIView(viewModel: viewModel)
                    AvailableRatesSectionSUIView(viewModel: viewModel)
                }
            }
            .navigationBarTitle("Currency Conversion!").toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.destructiveAction) {
                    Button("clear cache") {
                        AppManager.config.database.clear()
                    }
                }
            }
        } initialize: {
            viewModel.fetchAvailableCurrencies {
                self.initialized = true
            }
        }
    }
}

@available(iOS 14, *)
struct ConvertFromSectionSUIView: View {
    @ObservedObject var viewModel: CurrencyConversionSViewStateModel
    
    var body: some View {
        Section(header: Text("Convert From")) {
            CurrencyPickerSView(selectedCurrency: $viewModel.fromCurrency,
                                availableCurrencies: viewModel.availableCurrencies)
            
            if !viewModel.availableCurrencies.isEmpty &&
                !viewModel.fromCurrency.isEmpty {
                FormTextFieldSView(enteredText: $viewModel.amount, label: "Amount", onCommit: {
                    viewModel.fetchActiveExchangeRates { }
                })
                
                if viewModel.isValidAmount() != nil {
                    HStack {
                        Spacer()
                        Button(action: {
                            UIApplication.shared.endEditing()
                            viewModel.fetchActiveExchangeRates { }
                            
                        }, label: {
                            Text("Convert!")
                        })
                    }.padding(.vertical, 5)
                }
            }
        }
    }
}


@available(iOS 14, *)
struct AvailableRatesSectionSUIView: View {
    
    static let gridSpacing: CGFloat = 10
    static let cornerRadius: CGFloat = 10
    
    var columns: [GridItem] = {
        return [GridItem(.adaptive(minimum: 100), spacing: Self.gridSpacing),
                GridItem(.adaptive(minimum: 100), spacing: Self.gridSpacing)]
        
    }()
    
    static var numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter
    }()
    
    static func numberFormatter(with localId:String) -> NumberFormatter {
        numberFormatter.currencyCode = localId
        return numberFormatter
    }
    
    @ObservedObject var viewModel: CurrencyConversionSViewStateModel
    
    var body: some View {
        if viewModel.availableExchangeRates.count > 0 &&
            viewModel.isValidAmount() != nil {
            
            Section(header: Text("Current Rates")) {
                LazyVGrid(columns: columns, alignment: .center, spacing: Self.gridSpacing) {
                    ForEach(0..<viewModel.availableExchangeRates.count) { (index) in
                        VStack {
                            let _exchangeRate = viewModel.availableExchangeRates[index]
                            
                            if let name = viewModel.abbreviationToLocalizedName[_exchangeRate.toCurrencyAbbrev] {
                                Text(name)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.vertical)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text(_exchangeRate.toCurrencyAbbrev)
                                    .padding(.vertical)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Text("\(NSNumber(value: _exchangeRate.rate), formatter: Self.numberFormatter(with: _exchangeRate.toCurrencyAbbrev) )")
                                .fixedSize(horizontal: false, vertical: true)
                                .padding()
                                .multilineTextAlignment(.center)
                        }
                        .padding(.vertical)
                        .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(Self.cornerRadius)
                    }
                }
            }
        } else {
            EmptyView()
        }
    }
}


@available(iOS 14, *)
struct SUI_CurrencyConversionView_Previews: PreviewProvider {
    struct MockCurrency: Currency {
        var abbreviation: String
        var localizedName: String
        var isEmpty: Bool = false
    }
    
    struct MockCurrencyExchangeRate: CurrencyExchangeRate {
        var fromCurrencyAbbrev: String
        var toCurrencyAbbrev: String
        var rate: Double
        init(fromCurrencyAbbrev: String, toCurrencyAbbrev: String, rate: Double) {
            self.fromCurrencyAbbrev = fromCurrencyAbbrev
            self.toCurrencyAbbrev = toCurrencyAbbrev
            self.rate = rate
        }
    }
    
    struct MockCancelable: Cancelable {
        func cancel() { }
    }
    
    class MockCurrencyAPI: BaseAPIImpl, CurrencyConversionAPI {
        func exchangeRates(fromCurrency: Currency, amount: Double, completion: @escaping ([CurrencyExchangeRate]) -> Void) -> Cancelable? {
           
            completion([ MockCurrencyExchangeRate(fromCurrencyAbbrev: "XYZ", toCurrencyAbbrev: "JPY", rate: 1000)])
            return nil
        }
        
        func getCurrencies(completion: @escaping ([Currency]) -> Void) -> Cancelable? {
            completion([MockCurrency(abbreviation: "XYZ", localizedName: "xorborg"),
                        MockCurrency(abbreviation: "GED", localizedName: "global"),
                        MockCurrency(abbreviation: "JPY", localizedName: "Japan")])
            return MockCancelable()
        }
        
        func convert(fromCurrency: Currency, amount: Double, toCurrency: Currency, completion: @escaping (Double?) -> Void) -> Cancelable? {
            completion(nil)
            return MockCancelable()
        }
    }
    
    static var testViewModel = CurrencyConversionSViewStateModel(api: MockCurrencyAPI())
    static var previews: some View {
        NavigationView {
            CurrencyConversionSView(viewModel: testViewModel)
        }
    }
}

