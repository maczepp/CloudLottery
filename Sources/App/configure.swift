import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)

    // Configure a database
    var databases = DatabasesConfig()
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    
    let databaseConfig = PostgreSQLDatabaseConfig(
        hostname: hostname, username: username, database: databaseName, password: password)
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: MegaSena.self, database: .psql)
    services.register(migrations)
    
    //var migrations = MigrationConfig()
    migrations.add(model: MegaSenaStatistics.self, database: .psql)
    services.register(migrations)
}