//
// https://currencylayer.com/documentation
//

import Foundation

/**
    Currency Layer Response
*/
protocol CLResponse: Decodable {
    var success: Bool { get }
    var terms: URL { get }
    var privacy: URL { get }
}

/**
 
 ## Parameters:
 - timestamp : 1432480209
 
 */
protocol CLTimeStampResponse: CLResponse {
    var timestamp: TimeInterval { get }
}

/**
 https://api.currencylayer.com/list
 
 ##### Paramters:
 - access_key = YOUR_ACCESS_KEY
 
     "currencies": {
         "AED": "United Arab Emirates Dirham",
         "AFN": "Afghan Afghani",
         "ALL": "Albanian Lek",
         "AMD": "Armenian Dram",
         "ANG": "Netherlands Antillean Guilder"
     }
 
*/
protocol SupportedCurrencyLayerResponse: CLResponse {
    var currencies: [Currency] { get }
}

/**
 https://api.currencylayer.com/active
 
 ##### Paramters:
 - access_key = YOUR_ACCESS_KEY
 
     "quotes": {
         "AED": 1.2,
         "AFN": 1.2,
         "ALL": 1.2,
         "AMD": 1.2,
         "ANG": 1.2
     }
 
*/
protocol ActiveCurrencyRatesResponse: CLTimeStampResponse {
    var source: String { get }
    var rates: CurrencyExchangeRates { get }
}

/**
 https://api.currencylayer.com/convert
     
 ## Paramters:
 - access_key = YOUR_ACCESS_KEY
 - from = USD
 - to = GBP
 - amount = 10
 
 
     "query": {
         "from": "USD",
         "to": "GBP",
         "amount": 10
     },
     "info": {
         "timestamp": 1430068515,
         "quote": 0.658443
     },
     "result": 6.58443
 
*/
protocol ConvertCurrencyLayerResponse: CLTimeStampResponse {
    var result: Double { get }
    
}
