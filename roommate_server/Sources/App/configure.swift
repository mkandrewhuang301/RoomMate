import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.logger.logLevel = .debug
    app.http.server.configuration.hostname = "0.0.0.0"
    app.http.server.configuration.port = 8080

    app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: "localhost",
        port: 5432,
        username: "postgres",
        password: "123456",
        database: "userlist",
        // tls: .prefer(try .init(configuration: .clientDefault))
        tls: .disable
        )
    ), as: .psql) 
    

    app.migrations.add(CreateUserList())

    // register routes
    try routes(app)
}
