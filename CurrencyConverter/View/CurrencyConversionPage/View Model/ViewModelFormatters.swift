
import Foundation

struct CurrencyConversionViewFormatters {
    static var currencyNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .currencyAccounting
        return formatter
    }()
    
    static func currencyNumberFormatter(with localId:String) -> NumberFormatter {
        currencyNumberFormatter.currencyCode = localId
        return currencyNumberFormatter
    }
    
    
    struct DigitFormatter {
        static let maxIntegersDigits = 20
        static let maxFractionsDigits = 6
        static func formatText(prevValue: String, newValue: String) -> String {
            if prevValue.last != "." && newValue.last == "." {
                return newValue
            }
            
            let components = newValue.components(separatedBy: ".")
            if components.count == 2 {
                
                var returnValue = ""
                if components[0].count <= maxIntegersDigits {
                    returnValue = newValue
                } else {
                    returnValue = prevValue
                }
                if components[1].count <= maxFractionsDigits {
                    returnValue = newValue
                } else {
                    returnValue = prevValue
                }
                return returnValue
            } else {
                if components[0].count <= maxIntegersDigits {
                    return newValue
                } else {
                    return prevValue
                }
            }
        }
    }
}
