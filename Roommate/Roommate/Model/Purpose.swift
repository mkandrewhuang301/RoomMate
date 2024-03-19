import Foundation

enum Purpose: String, Codable, CaseIterable {
    case College = "College"
    case Internship = "Internship"
    case FullTime = "FullTime"
    case Unknown = "Unknown"
}
