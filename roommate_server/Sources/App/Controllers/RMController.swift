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
}
