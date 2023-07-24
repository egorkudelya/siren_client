import Foundation

struct SirenCoreResponse : Codable {
    let core_code: Int
    let body: [String: [String: UInt64]]
}
