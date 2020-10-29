# Currency Converter App

## Installation 

0.  Acquire an API key from https://currencylayer.com/

1.  Create `Secrets.swift` in directory `CurrencyConverter/AppResources`



**Secrets.swift:**

```swift

enum Secrets {
    static let apiKey = "<Your Currency Layer API Key>"
}

```

2. `bundle install` at project root

3. `bundle exec pod install` at project root

4. `open CurrencyConverter.xcworkspace`

