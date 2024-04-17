import Fluent
import Vapor

struct Preference: Codable {
    var gender: Gender
    var ageRange: Range
    var sameSchool: Bool 
    var sameMajor: Bool
}