import Fluent
import Vapor
import Foundation

struct CreateUserList: AsyncMigration {
    func prepare(on database: Database) async throws {
        database.logger.info("Creating userlist table")
        do {
        try await database.schema("userlist")
            .id()
            .field("fName", .string, .required)
            .field("lName", .string, .required)
            .field("DUID", .int, .required)
            .field("netId", .string, .required)
            .field("gender", .string)
            .field("friends", .array(of: .uuid))
            .field("applyList", .array(of: .uuid))
            .field("waitList", .array(of: .uuid))
            .field("seen", .array(of: .uuid))
            .field("purpose", .string)
            .field("photos", .array(of: .string))
            .field("school", .string)
            .field("major", .string)
            .field("gradYear", .int)
            .field("age", .int)
            .field("sleepSchedule", .dictionary)
            .field("budget", .dictionary)
            .field("isSmoke", .bool)
            .field("havePets", .bool)
            .field("selfIntro", .string)
            .field("haveRoom", .bool)
            .field("room", .dictionary)
            .field("preference", .dictionary)
            .field("location", .string)
            .field("interests", .array(of: .string))
            .create()
        } catch {
            print(String(reflecting: error))
        }
        
        let directory = DirectoryConfiguration.detect().workingDirectory
        let filePath = directory + "Resources/initdata.json"

        guard let data = FileManager.default.contents(atPath: filePath) else {
            print("Fail！")
            return
        }
        
        guard let users = try? JSONDecoder().decode([User].self, from: data) else {
            print("Fail！")
            return
        }
        
        // try await users.create(on: database)
        for user in users {
            try await user.save(on: database)
        }
    }

    func revert(on database: Database) async throws {
        try await database.schema("userlist").delete()
    }
}
