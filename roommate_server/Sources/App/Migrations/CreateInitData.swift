// import Fluent
// import Vapor
// import Foundation

// struct CreateInitData: AsyncMigration {
//     func prepare(on database: Database)  async throws {
    
//         let directory = DirectoryConfiguration.detect().workingDirectory
//         let filePath = directory + "Resources/initdata.json"
        

//         guard let data = FileManager.default.contents(atPath: filePath) else {
//             return database.eventLoop.makeFailedFuture(FluentError.idRequired) 
//         }
        
//         guard let users = try? JSONDecoder().decode([User].self, from: data) else {
//             return database.eventLoop.makeFailedFuture(FluentError.idRequired)
//         }
        
//         return try await users.create(on: database)
//     }

//     func revert(on database: Database) async throws {
//         try await User.query(on: database).delete()
//     }
// }


// // struct CreateInitData: Command {
// //     struct Signature: CommandSignature {}
// //     let help = "Inserts default data into the database."

// //     func run(using context: CommandContext, signature: Signature) throws {
// //         context.console.print("start")
// //         let directory = DirectoryConfiguration.detect().workingDirectory
// //         let filePath = directory + "Resources/initdata.json"
// //         let fileURL = URL(fileURLWithPath: filePath)
// //         let data = try Data(contentsOf: fileURL)
// //         let decoder = JSONDecoder()

// //         let users = try decoder.decode([User].self, from: data)

// //         for user in users {
// //             try user.save(on: context.application.db).wait()
// //         }

// //         context.console.print("Default data inserted successfully.")
// //     }
// // }