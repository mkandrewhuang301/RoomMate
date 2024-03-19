import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "userlist"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "fName")
    var fName: String

    @Field(key: "lName")
    var lName: String

    @Field(key: "DUID")
    var DUID: UInt

    @Field(key: "netId")
    var netId: String

    @Field(key: "gender")
    var gender: Gender

    @Field(key: "friends")
    var friends: [UInt]

    @Field(key: "purpose")
    var purpose: Purpose

    @Field(key: "photos")
    var photos: [String]

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

    init() { }

    init(id: UUID? = nil, fName: String, lName: String, DUID: UInt, netId: String) {
        self.id = id
        self.fName = fName
        self.lName = lName
        self.DUID = DUID
        self.netId = netId
    }
}
