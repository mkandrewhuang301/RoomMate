import Foundation

struct User: Codable, Identifiable {
    
    var id: UUID
    
    var fName: String = "Unknown"

    var lName: String = "Unknown"

    let DUID: UInt

    let netId: String

    var gender: Gender = .Unknown

    var friends: [UInt] = []

    var purpose: Purpose = .Unknown

    var photos: [String] = []

    var school: School = .NotApplicable
    
    var program: Program = .NotApplicable
    
    var major: Major = .NotApplicable
    
    var gradYear:UInt = 0

    var age: UInt = 0

    var sleepSchedule: Range = Range(min: 0, max: 0)

    var budget: Range = Range(min: 0, max: 0)

    var isSmoke: Bool = false

    var havePets: Bool = false

    var selfIntro: String = ""

    var haveRoom: Bool = false

    var room: Room = Room()

    var preference: Preference = Preference()

    var location: String = ""

    var interests: [String] = []

    init(_ DUID: UInt, _ netId: String) {
        self.id = UUID()
        self.DUID = DUID
        self.netId = netId
        
    }
}
