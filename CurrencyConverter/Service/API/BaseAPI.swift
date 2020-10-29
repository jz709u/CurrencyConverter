
import Foundation

protocol BaseAPI {
    var session: CCURLSession { get }
    var database: Database { get }
}

class BaseAPIImpl: BaseAPI {
    
    let session: CCURLSession
    let jsonDecoder = JSONDecoder()
    let database: Database
    
    // MARK: - Life Cycle
    
    required init(session: CCURLSession = URLSession.shared,
                  database: Database = AppManager.config.database) {
        self.session = session
        self.database = database
    }
}
