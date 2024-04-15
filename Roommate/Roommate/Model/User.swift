import Foundation

struct User: Codable, Identifiable {
    
    var id: UUID
    
    var fName: String = "Unknown"

    var lName: String = "Unknown"

    let DUID: UInt

    let netId: String

    var gender: Gender = .Unknown

//    var friends: [UInt] = []
    var friends: [UUID] = []
    
    var applyList: [UUID] = []
    
    var waitList: [UUID] = []
    
    var seen: [UUID] = []

    var purpose: Purpose = .Unknown

    var photos: [String] = [] /// 4 photos
    

    var school: School = .NotApplicable
    
    //var program: Program = .NotApplicable
    
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

    var preference: Preference = Preference() //5

    var location: String = ""

    var interests: [String] = []

    init(id: UUID? = nil, DUID: UInt? = nil, netId: String? = nil, fName: String? = nil, lName: String? = nil, gender: Gender? = nil, purpose: Purpose? = nil, photos: [String]? = nil, school: School? = nil, major: Major? = nil, gradYear: UInt? = nil, sleepSchedule: Range? = nil, budget: Range? = nil, isSmoke: Bool? = nil, havePets: Bool? = nil, selfIntro: String? = nil, room: Room? = nil, preference: Preference? = nil, location: String? = nil, interests: [String]? = nil) {
           self.id = id ?? UUID()
           self.DUID = DUID ?? 0
           self.netId = netId ?? ""
           self.fName = fName ?? "Unknown"
           self.lName = lName ?? "Unknown"
           self.gender = gender ?? .Unknown
           self.purpose = purpose ?? .Unknown
           self.photos = photos ?? []
           self.school = school ?? .NotApplicable
           //self.program = program ?? .NotApplicable
           self.major = major ?? .NotApplicable
           self.gradYear = gradYear ?? 0
           self.sleepSchedule = sleepSchedule ?? Range(min: 0, max: 0)
           self.budget = budget ?? Range(min: 0, max: 0)
           self.isSmoke = isSmoke ?? false
           self.havePets = havePets ?? false
           self.selfIntro = selfIntro ?? ""
           self.room = room ?? Room()
           self.preference = preference ?? Preference()
           self.location = location ?? ""
           self.interests = interests ?? []
       }}
