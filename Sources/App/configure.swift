import Fluent
import FluentPostgresDriver
import Vapor

// Configure migrations, database connection, register routes (endpoints)...
public func configure(_ app: Application) throws {
    // Allow program to access public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    guard let jwtKey = Environment.process.JWT_KEY else { fatalError("JWT_KEY not found") }
    guard let _ = Environment.process.API_KEY else { fatalError("API_KEY not found") }
    guard let dbURL = Environment.process.DATABASE_URL else { fatalError("DATABASE_URL not found") }
    guard let _ = Environment.process.APP_BUNDLE_ID else { fatalError("APP_BUNDLE_ID not found") }
    
    // DB connection
    try app.databases.use(.postgres(url: dbURL), as: .psql)
    

    // register routes
    try routes(app)
}
