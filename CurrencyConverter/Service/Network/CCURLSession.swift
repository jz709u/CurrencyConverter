import Foundation

protocol CCURLSession {
    func dataTaskToDeserialize<T: Decodable>(object: T.Type,
                                             from url: URL,
                                             with completion: @escaping (_ result: Result<T,Error>) -> Void) -> URLSessionDataTask
}

extension URLSession: CCURLSession {
    
    enum Errors: Error {
        case UnknownError
    }
    
    func dataTaskToDeserialize<T: Decodable>(object: T.Type,
                                             from url: URL,
                                             with completion: @escaping (_ result: Result<T,Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data,
               let decodedObject = try? decoder.decode(object, from: data) {
                completion(.success(decodedObject))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(Errors.UnknownError))
            }
        }
    }
}
