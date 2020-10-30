
import SwiftUI

@available(iOS 14, *)
struct CurrencyConversionSView: View {
    
    @State private var initialized = false
    
    @ObservedObject private var viewModel: CurrencyConversionViewStateModel
    
    init(viewModel: CurrencyConversionViewStateModel = CurrencyConversionViewStateModel()) {
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
    @ObservedObject var viewModel: CurrencyConversionViewStateModel
    
    var body: some View {
        Section(header: Text("Convert From")) {
            
            // picker cell
            CurrencyPickerSView(selectedCurrency: $viewModel.fromCurrency,
                                availableCurrencies: viewModel.availableCurrencies)
            
            // available currencies and from currency is set
            if !viewModel.availableCurrencies.isEmpty &&
                !viewModel.fromCurrency.isEmpty {
                
                // amount text field
                FormTextFieldSView(enteredText: $viewModel.amount,
                                   label: "Amount",
                                   onCommit: {
                    viewModel.fetchActiveExchangeRates { }
                })
                
                // if amount is valid then show convert button
                if viewModel.isValidAmount() != nil {
                    self.convertButtonCell()
                }
            }
        }
    }
    
    func convertButtonCell() -> some View {
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


@available(iOS 14, *)
struct AvailableRatesSectionSUIView: View {
    
    private static let gridSpacing: CGFloat = 10
    private static let cellSize: CGFloat = 150
    
    private let columns: [GridItem] = {
        [GridItem(.adaptive(minimum: Self.cellSize),
                  spacing: Self.gridSpacing),
         GridItem(.adaptive(minimum: Self.cellSize),
                  spacing: Self.gridSpacing)]
        
    }()
    
    @ObservedObject var viewModel: CurrencyConversionViewStateModel
    
    var body: some View {
        if viewModel.availableExchangeRates.count > 0 &&
            viewModel.isValidAmount() != nil {
            
            Section(header: Text("Current Rates")) {
                LazyVGrid(columns: columns,
                          alignment: .center,
                          spacing: Self.gridSpacing) {
                    
                    ForEach(0..<viewModel.availableExchangeRates.count) { (index) in
                        
                        let rate = viewModel.availableExchangeRates[index]
                        
                        CurrencyConversionSViewGridCell(gridSize: Self.cellSize,
                                                        viewModel: rate,
                                                        localizedName: viewModel.abbreviationToLocalizedName[rate.toCurrencyAbbrev])
                    }
                }.padding(.vertical, Self.gridSpacing)
            }
            
        } else {
            EmptyView()
        }
    }
}

@available(iOS 14, *)
struct CurrencyConversionSViewGridCell: View {
    
    static let cornerRadius: CGFloat = 10
    
    let gridSize: CGFloat
    let viewModel: CurrencyExchangeRate
    var localizedName: String?
    
    var body: some View {
        VStack {
            let displayName = localizedName ?? viewModel.toCurrencyAbbrev
            
            Text(displayName)
                .fixedSize(horizontal: false,
                           vertical: true)
                .padding()
                .multilineTextAlignment(.center)
            
            Text("\(NSNumber(value: viewModel.rate),formatter: CurrencyConversionViewFormatters.currencyNumberFormatter(with: viewModel.toCurrencyAbbrev) )")
                .fixedSize(horizontal: false,
                           vertical: true)
                .padding()
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
        .frame(width: gridSize,
               height: gridSize,
               alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(Self.cornerRadius)
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
    
    static var testViewModel = CurrencyConversionViewStateModel(api: MockCurrencyAPI())
    static var previews: some View {
        NavigationView {
            CurrencyConversionSView(viewModel: testViewModel)
        }
    }
}

