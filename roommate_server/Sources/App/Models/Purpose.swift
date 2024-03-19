import Fluent
import Vapor

enum Purpose: String, Codable {
    case College = "College"
    case Internship = "Internship"
    case FullTime = "FullTime"
}