import Foundation

struct Preference: Codable {
    var gender: Gender = .Unknown
    var ageRange: Range = Range(min: 0, max: 0)
    var sameSchool: Bool = false
    var sameProgram: Bool = false
    var sameMajor: Bool = false
    
    init() { }
    
    init(gender: Gender, ageRange: Range, sameSchool: Bool, sameProgram: Bool, sameMajor: Bool) {
        self.gender = gender
        self.ageRange = ageRange
        self.sameSchool = sameSchool
        self.sameProgram = sameProgram
        self.sameMajor = sameMajor
    }
}
