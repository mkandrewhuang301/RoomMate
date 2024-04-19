import Fluent
import Vapor
import Foundation

final class User: Model, Content {
    static let schema = "userlist"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "fName")
    var fName: String

    @Field(key: "lName")
    var lName: String

    @Field(key: "DUID")
    var DUID: Int

    @Field(key: "netId")
    var netId: String

    @Field(key: "gender")
    var gender: Gender

    @Field(key: "friends")
    var friends: [UUID]
    
    @Field(key: "applyList")
    var applyList: [UUID]
    
    @Field(key: "waitList")
    var waitList: [UUID]

    @Field(key: "seen")
    var seen: [UUID]

    @Field(key: "purpose")
    var purpose: Purpose

    @Field(key: "photos")
    var photos: [String]

    @Field(key: "school")
    var school: School

    @Field(key: "major")
    var major: Major

    @Field(key: "gradYear")
    var gradYear: Int

    @Field(key: "age")
    var age: Int

    @Field(key: "sleepSchedule")
    var sleepSchedule: Range

    @Field(key: "budget")
    var budget: Range

    @Field(key: "isSmoke")
    var isSmoke: Bool

    @Field(key: "havePets")
    var havePets: Bool

    @Field(key: "selfIntro")
    var selfIntro: String

    @Field(key: "haveRoom")
    var haveRoom: Bool

    @Field(key: "room")
    var room: Room

    @Field(key: "preference")
    var preference: Preference

    @Field(key: "location")
    var location: String

    @Field(key: "interests")
    var interests: [String]

    init() {}

    // init(DUID: UInt, netId: String, fName: String, lName: String, 
    // gender: Gender, friends: [UInt], purpose: Purpose, photos: [String], 
    // major: Major, gradYear: Int, age: Int, sleepSchedule: Range, 
    // budget: Range, isSmoke: Bool, havePets: Bool, selfIntro: String, 
    // haveRoom: Bool, room: Room, preference: Preference, location: String, 
    // interests: [String]) {
    //     self.id = UUID()
    //     self.DUID = DUID
    //     self.netId = netId
    //     self.fName = fName
    //     self.lName = lName
    //     self.gender = gender
    //     self.friends = friends
    //     self.purpose = purpose
    //     self.photos = photos
    //     self.major = major
    //     self.gradYear = gradYear
    //     self.age = age
    //     self.sleepSchedule = sleepSchedule
    //     self.budget = budget
    //     self.isSmoke = isSmoke
    //     self.havePets = havePets
    //     self.selfIntro = selfIntro
    //     self.haveRoom = haveRoom
    //     self.room = room
    //     self.preference = preference
    //     self.location = location
    //     self.interests = interests
    // }

}
