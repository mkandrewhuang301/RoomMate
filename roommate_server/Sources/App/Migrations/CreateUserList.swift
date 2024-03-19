import Fluent

struct CreateUserList: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("userlist")
            .id()
            .field("fName", .string, .required)
            .field("lName", .string, .required)
            .field("DUID", .uint, .required)
            .field("netId", .string, .required)
            .field("gender", .string)
            .field("friends", .json)
            .field("purpose", .string)
            .field("photos", .json)
            .field("major", .string)
            .field("gradYear", .int)
            .field("age", .int)
            .field("sleepSchedule", .json)
            .field("budget", .json)
            .field("isSmoke", .bool)
            .field("havePets", .bool)
            .field("selfIntro", .string)
            .field("haveRoom", .bool)
            .field("room", .json)
            .field("preference", .json)
            .field("location", .string)
            .field("interests", .json)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("userlist").delete()
    }
}
