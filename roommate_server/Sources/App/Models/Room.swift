import Fluent
import Vapor

struct Room: Codable {
    var roomNumber: Int
    var location: String
    var description: String
    var photos: [String]
}