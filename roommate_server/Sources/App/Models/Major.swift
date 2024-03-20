import Fluent
import Vapor

enum Major: String, Codable {
    case CS = "Computer Science"
    case ECE = "ECE"
    case FinTech = "FinTech"
    case Other = "Other"
    case NotApplicable = "NA"
}