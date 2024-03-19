import Fluent
import Vapor

struct Preference: Codable {
    var gender: Gender
    var ageRange: Range
    var sameCollege: Bool
}