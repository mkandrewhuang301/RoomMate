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
        subroutes.group("add-default") { subroute in
            subroute.get(use: addDefault)
        }
        subroutes.group("apply") { subroute in
            subroute.post(use: applyForMatch)
        }
        subroutes.group("accept") { subroute in
            subroute.post(use: acceptForMatch)
        }
        subroutes.group("reject") { subroute in
            subroute.post(use: rejectForMatch)
        }
        subroutes.group("delete") { subroute in
            subroute.post(use: deleteFriend)
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
        let userData = try req.content.decode(User.self)

        return User.find(userData.id, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { user in
            user.fName = userData.fName
            user.lName = userData.lName
            user.DUID = userData.DUID
            user.netId = userData.netId    
            user.gender = userData.gender
            user.friends = userData.friends
            user.applyList = userData.applyList
            user.waitList = userData.waitList
            user.purpose = userData.purpose
            user.photos = userData.photos
            user.school = userData.school
            user.major = userData.major
            user.gradYear = userData.gradYear
            user.age = userData.age
            user.sleepSchedule = userData.sleepSchedule
            user.budget = userData.budget
            user.isSmoke = userData.isSmoke
            user.havePets = userData.havePets
            user.selfIntro = userData.selfIntro
            user.haveRoom = userData.haveRoom
            user.room = userData.room
            user.preference = userData.preference
            user.location = userData.location
            user.interests = userData.interests
            return user.save(on: req.db).map { user }
        }
}

    func addDefault(req: Request) throws -> EventLoopFuture<[User]> {
        let directory = DirectoryConfiguration.detect().workingDirectory
        let filePath = directory + "Resources/initdata.json"
        

        guard let data = FileManager.default.contents(atPath: filePath) else {
            print("Fail！")
            throw Abort(.notFound, reason: "File not found")
        }

        do {
            let users = try JSONDecoder().decode([User].self, from: data)
            return users.create(on: req.db).map { users }
        } catch  let error as DecodingError {
    switch error {
    case .dataCorrupted(let context):
        print("Data corrupted: \(context)")
    case .keyNotFound(let key, let context):
        print("Key '\(key)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
    case .typeMismatch(let type, let context):
        print("Type '\(type)' mismatch: \(context.debugDescription), codingPath: \(context.codingPath)")
    case .valueNotFound(let type, let context):
        print("Value '\(type)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
    @unknown default:
        print("Unknown decoding error: \(error)")
    }
            throw Abort(.notFound, reason: "Fail to decode")
        }
    }

    func applyForMatch(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let matchRequest = try req.content.decode(MatchRequest.self)
        
         return User.find(matchRequest.myid, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { currentUser in
            User.find(matchRequest.matchid, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { userToMatch in
                    if userToMatch.applyList.contains(currentUser.id!) {
                        userToMatch.applyList.removeAll { $0 == currentUser.id! }
                        userToMatch.friends.append(currentUser.id!)
                        currentUser.friends.append(userToMatch.id!)
                    } else {
                        currentUser.applyList.append(userToMatch.id!)
                        userToMatch.waitList.append(currentUser.id!)
                    }
                    return currentUser.save(on: req.db).flatMap {
                        userToMatch.save(on: req.db).map { userToMatch }
                    }
                }.transform(to: .ok)
        }
    }

    func acceptForMatch(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let matchRequest = try req.content.decode(MatchRequest.self)
        
         return User.find(matchRequest.myid, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { currentUser in
            User.find(matchRequest.matchid, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { userToMatch in
                    currentUser.waitList.removeAll { $0 == userToMatch.id! }
                    userToMatch.applyList.removeAll { $0 == currentUser.id! }
                    currentUser.friends.append(userToMatch.id!)
                    userToMatch.friends.append(currentUser.id!)
                    return currentUser.save(on: req.db).flatMap {
                        userToMatch.save(on: req.db).map { userToMatch }
                    }
                }.transform(to: .ok)
        }
    }

    func rejectForMatch(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let matchRequest = try req.content.decode(MatchRequest.self)
        
         return User.find(matchRequest.myid, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { currentUser in
            User.find(matchRequest.matchid, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { userToMatch in
                    currentUser.waitList.removeAll { $0 == userToMatch.id! }
                    userToMatch.applyList.removeAll { $0 == currentUser.id! }
                    return currentUser.save(on: req.db).flatMap {
                        userToMatch.save(on: req.db).map { userToMatch }
                    }
                }.transform(to: .ok)
        }
    }

    func deleteFriend(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let matchRequest = try req.content.decode(MatchRequest.self)
        
         return User.find(matchRequest.myid, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { currentUser in
            User.find(matchRequest.matchid, on: req.db)
                .unwrap(or: Abort(.notFound))
                .flatMap { userToMatch in
                    currentUser.friends.removeAll { $0 == userToMatch.id! }
                    userToMatch.friends.removeAll { $0 == currentUser.id! }
                    return currentUser.save(on: req.db).flatMap {
                        userToMatch.save(on: req.db).map { userToMatch }
                    }
                }.transform(to: .ok)
        }
    }
}
