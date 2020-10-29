import Foundation

protocol Cancelable {
    func cancel()
}

extension URLSessionTask: Cancelable { }
