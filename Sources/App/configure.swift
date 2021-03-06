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
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    //let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let databaseName: String
    let databasePort: Int
    
    if (env == .testing) {
        databaseName = "vapor-test"
        if let testPort = Environment.get("DATABASE_PORT") {
            databasePort = Int(testPort) ?? 5433
        } else {
            databasePort = 5433
        }
    } else {
        databaseName = Environment.get("DATABASE_DB") ?? "vapor"
        databasePort = 5432
    }
    
    let databaseConfig = PostgreSQLDatabaseConfig(hostname: hostname, port: databasePort, username: username, database: databaseName, password: password)
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    var commandConfig = CommandConfig.default()
    commandConfig.useFluentCommands()
    services.register(commandConfig)
    
    
    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: MegaSena.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: Quina.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: LotoFacil.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: LotoMania.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: DuplaSena.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: TimeMania.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: MegaSenaStatistics.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: QuinaStatistics.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: LotoFacilStatistics.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: LotoManiaStatistics.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: DuplaSenaStatistics.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: TimeManiaStatistics.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: DiaDeSorteStatistics.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: MyAnalytics.self, database: .psql)
    services.register(migrations)
    
    migrations.add(model: NewAnalytics.self, database: .psql)
    services.register(migrations)
}
