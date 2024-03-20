import Fluent
import Vapor

struct RMController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let subroutes = routes.grouped("roommate")
        subroutes.group("user", ":netId") { subroute in
            subroute.get(use: getUser)
        }
        subroutes.group("list") { subroute in
            subroute.get(use: getAll)
        }
        subroutes.group("modify-profile") { subroute in
            subroute.post(use: modifyProfile)
        }
        // subroutes.group("add-default") { subroute in
        //     subroute.get(use: addDefault)
        // }
    }

    func getUser(req: Request) throws -> EventLoopFuture<User> {
        let netId = req.parameters.get("netId")!
        return User.query(on: req.db)
            .filter(\.$netId == netId)
            .first()
            .unwrap(or: Abort(.notFound))
    }

    func getAll(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }

    func modifyProfile(req: Request) throws -> EventLoopFuture<User> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).map { user }
    }

    // func addDefault(req: Request) throws -> EventLoopFuture<[User]> {
    //     let directory = DirectoryConfiguration.detect().workingDirectory
    //     let filePath = directory + "Resources/initdata.json"
        

    //     guard let data = FileManager.default.contents(atPath: filePath) else {
    //         print("Fail！")
    //         throw Abort(.notFound, reason: "File not found")
    //     }

    //     do {
    //         let users = try JSONDecoder().decode([User].self, from: data)
    //         return users.create(on: req.db).map { users }
    //     } catch  let error as DecodingError {
    // // 捕获解码错误，并打印详细信息
    // switch error {
    // case .dataCorrupted(let context):
    //     print("Data corrupted: \(context)")
    // case .keyNotFound(let key, let context):
    //     print("Key '\(key)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
    // case .typeMismatch(let type, let context):
    //     print("Type '\(type)' mismatch: \(context.debugDescription), codingPath: \(context.codingPath)")
    // case .valueNotFound(let type, let context):
    //     print("Value '\(type)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
    // @unknown default:
    //     print("Unknown decoding error: \(error)")
    // }
    //         throw Abort(.notFound, reason: "Fail to decode")
    //     }
    // }
}
