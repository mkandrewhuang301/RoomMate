import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080
    
    // app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
    //     hostname: Environment.get("DATABASE_HOST") ?? "localhost",
    //     port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
    //     username: Environment.get("DATABASE_USERNAME") ?? "postgres",
    //     password: Environment.get("DATABASE_PASSWORD") ?? "password",
    //     database: Environment.get("DATABASE_NAME") ?? "userlist",
    //     tls: .prefer(try .init(configuration: .clientDefault)))
    // ), as: .psql)

    // app.migrations.add(CreateUserList())

    // register routes
    try routes(app)
}
