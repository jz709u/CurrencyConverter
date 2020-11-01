
import Foundation

protocol APIable {
    var secure: Bool { get }
    var baseURLString: String { get }
    var url: URL? { get }
    func url(with parameters: [String: String]) -> URL?
    var keyAndAccessToken: (key: String, token: String)? { get }
}

extension APIable where Self: RawRepresentable,
                        Self.RawValue == String {
    
    var secure: Bool { true }
    
    func url(with parameters: [String: String]) -> URL? {
        guard let url = url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)  else { return nil }
        
        if components.queryItems == nil {
            components.queryItems = [URLQueryItem]()
        }
        
        for (k,v) in parameters {
            components.queryItems?.append(URLQueryItem(name: k, value: v))
        }
        
        if components.queryItems?.count == 0 {
            components.queryItems = nil
        }
        
        return components.url
    }
    
    var url: URL? {
        guard let urlWithEndpoint = urlWithEndpoint,
              var components = URLComponents(url: urlWithEndpoint, resolvingAgainstBaseURL: true) else { return nil }
        
        if components.queryItems == nil {
            components.queryItems = [URLQueryItem]()
        }
        
        components.scheme = secure ? "https" : "http"
        
        if let queryItemForAccessToken = queryItemForAccessToken {
            components.queryItems?.append(queryItemForAccessToken)
        }
        
        if components.queryItems?.count == 0 {
            components.queryItems = nil
        }
        
        return components.url
    }
    
    var queryItemForAccessToken: URLQueryItem? {
        guard let keyAndAccessToken = keyAndAccessToken else { return nil }
        return URLQueryItem(name: keyAndAccessToken.key, value: keyAndAccessToken.token)
    }
    
    var urlWithEndpoint: URL? { URL(string: baseURLString)?.appendingPathComponent(rawValue) }
}
