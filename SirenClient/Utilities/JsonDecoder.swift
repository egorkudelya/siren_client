import Foundation

func decodeJSON<T: Codable>(_ jsonString: String, to type: T.Type) -> T? {
    let data = Data(jsonString.utf8)
    let decoder = JSONDecoder()
    
    do {
        let decodedObject = try decoder.decode(type, from: data)
        return decodedObject
    }
    catch {
        return nil
    }
}

func decodeJSON<T: Codable>(_ jsonData: Data, to type: T.Type) -> T? {
    let decoder = JSONDecoder()
    
    do {
        let decodedObject = try decoder.decode(type, from: jsonData)
        return decodedObject
    }
    catch {
        return nil
    }
}
