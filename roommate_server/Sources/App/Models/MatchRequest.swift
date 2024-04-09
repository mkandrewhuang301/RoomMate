import Vapor

struct MatchRequest: Content {
    let myid: UUID
    let matchid: UUID
}