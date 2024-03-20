import Foundation

struct Room: Codable {
    var roomNumber: Int = 0
    var location: String = ""
    var description: String = ""
    var photos: [String] = []
    
    init() {}
    
    init(roomNumber: Int, location: String, description: String, photos: [String]) {
        self.roomNumber = roomNumber
        self.location = location
        self.description = description
        self.photos = photos
    }
}
