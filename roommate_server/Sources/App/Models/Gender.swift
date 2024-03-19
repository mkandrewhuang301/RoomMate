import Fluent
import Vapor

enum Gender: String, Codable {
    case Male = "Male"
    case Female = "Female"
    case Other = "Other"
    case Unknown = "Unknown"
}