import Foundation
import SwiftUI

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    private let cache = NSCache<NSString, UIImage>()
    private var baseURL = ""
    private var findRecordUrl = ""
    
    private override init() {
        super.init()
        self.baseURL = self.getEnvironmentVar("SERVER_DOMAIN") ?? ""
        self.findRecordUrl = self.baseURL + "/records/findByFingerprint"
    }
    
    private func getEnvironmentVar(_ name: String) -> String? {
        guard let rawValue = getenv(name) else {
            return nil
        }
        return String(utf8String: rawValue)
    }
    
    func getTrackMetadata(coreResponse: SirenCoreResponse, completed: @escaping (Result<SearchMatch, SError>) -> Void) {
        var request = URLRequest(url: URL(string: self.findRecordUrl)!)
        request.httpMethod = "POST"
        guard let bodyData = try? JSONEncoder().encode(coreResponse.body) else {
            completed(.failure(.invalidData))
            return
        }
        
        request.httpBody = bodyData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ =  error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            if let metadata = decodeJSON(data, to: SearchMatch.self) {
                completed(.success(metadata))
            }
            else {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
                
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}

