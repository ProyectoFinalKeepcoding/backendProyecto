import Fluent
import FluentPostgresDriver
import Vapor
import JWT

// Configure migrations, database connection, register routes (endpoints)...
public func configure(_ app: Application) async throws {
    // Allow program to access public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    guard let JWTKey = Environment.process.JWT_KEY else { fatalError("JWT_KEY not found") }
    guard let _ = Environment.process.API_KEY else { fatalError("API_KEY not found") }
    guard let dbURL = Environment.process.DATABASE_URL else { fatalError("DATABASE_URL not found") }
    guard let _ = Environment.process.APP_BUNDLE_ID else { fatalError("APP_BUNDLE_ID not found") }
    
    // Configure Jason Web Tokens to be encoded with the JWT of the .env file using the hs256 algorithm
    app.jwt.signers.use(.hs256(key: JWTKey))
    
    // DB connection
    try app.databases.use(.postgres(url: dbURL), as: .psql)
    
    // Migration of the models
    app.migrations.add(ModelsMigration())
    try await app.autoMigrate()

    // register routes
    try routes(app)
}
