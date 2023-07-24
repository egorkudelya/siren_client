import Foundation

struct Genre : Codable, Hashable {
    let name: String
}

struct Artist : Codable, Hashable {
    let name: String
}

struct Album : Codable, Hashable {
    let name: String
    let artUrl: String
    let isSingle: Bool
}

struct Error : Codable {
    let message: String
}

struct SearchMatch : Codable {
    let name: String
    let artUrl: String
    let duration: String
    var timestamp: String
    let bitRate: Int64
    let genres: [Genre]
    let artists: [Artist]
    let albums: [Album]
    let errors: [Error]
}

extension SearchMatch {
    static var defaultMatch: SearchMatch {
        SearchMatch(
            name: "Kashmir",
            artUrl: "https://upload.wikimedia.org/wikipedia/en/e/e3/Led_Zeppelin_-_Physical_Graffiti.jpg",
            duration: "508000",
            timestamp: "54000",
            bitRate: 320000,
            genres: [Genre(name: "Rock")],
            artists: [Artist(name: "Led Zeppelin")],
            albums: [Album(name: "Physical Graffiti", artUrl: "", isSingle: false)],
            errors: []
        )
    }
}
