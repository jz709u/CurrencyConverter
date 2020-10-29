import SwiftUI

@available(iOS 13, *)
struct CurrencyPickerSView: View {
    
    // MARK: - Variables
    
    @State var index: Int = 0
    @Binding var selectedCurrency: Currency
    var availableCurrencies: [Currency]
    
    // MARK: - View
    
    var body: some View {
        let binding = Binding {
            self.index
        } set: { (newValue) in
            self.index = newValue
            guard index < availableCurrencies.count else { return }
            selectedCurrency = availableCurrencies[index]
        }

        Picker(selection: binding,
               label: Text("Currency").font(.subheadline),
               content:{
                ForEach(0..<availableCurrencies.count) {(index) in
                        HStack {
                            Text(availableCurrencies[index].abbreviation)
                            Text(availableCurrencies[index].localizedName)
                        }
                    }
               }
        )
    }
}

@available(iOS 13, *)
struct InitializingSView<T:View>: View {
    
    // MARK: - Variables
    
    var content: () -> T
    var initialized: Bool
    var initializeClosure: () -> Void
    
    // MARK: - Life Cycle
    
    init(initialized: Bool, @ViewBuilder content: @escaping () -> T, initialize: @escaping () -> Void) {
        self.initialized = initialized
        self.content = content
        self.initializeClosure = initialize
    }
    
    // MARK: - View
    
    var body: some View {
        if !initialized {
            VStack {
                Text("Initializing...")
                    .bold()
                    .font(.title)
            }.onAppear {
                initializeClosure()
            }
        } else {
            content()
        }
    }
}

@available(iOS 13, *)
struct FormTextFieldSView: View {
    
    let maxIntegersDigits = 25
    let maxFractionsDigits = 6
    
    // MARK: - Variables
    
    @Binding var enteredText: String
    var label: String
    var onCommit: () -> Void
    
    // MARK: - Methods
    
    private func formatText(prevValue: String, newValue: String) {
        if prevValue.last != "." && newValue.last == "." {
            self.enteredText = newValue
            return
        }
        
        let components = newValue.components(separatedBy: ".")
        if components.count == 2 {
            if components[0].count < maxIntegersDigits {
                self.enteredText = newValue
            } else {
                self.enteredText = prevValue
            }
            if components[1].count < maxFractionsDigits {
                self.enteredText = newValue
            } else {
                self.enteredText = prevValue
            }
        } else {
            if components[0].count < maxIntegersDigits {
                self.enteredText = newValue
            } else {
                self.enteredText = prevValue
            }
        }
    }
    
    // MARK: - View
    
    var body: some View {
        let formatterText = Binding<String>(
            get: { self.enteredText },
            set: { self.formatText(prevValue: self.enteredText,
                                   newValue: $0)
            })
        
        HStack(alignment: .firstTextBaseline, spacing: 10, content: {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.black)
            Spacer()
            
            TextField("enter",
                      text: formatterText,
                      onCommit:  {
                onCommit()
                      })
                .multilineTextAlignment(.trailing)
                .frame( alignment: .trailing)
            .keyboardType(UIKeyboardType.decimalPad)
        })
    }
}
