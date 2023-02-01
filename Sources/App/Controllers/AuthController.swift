
import Vapor
import Fluent

struct AuthController: RouteCollection {

    // MARK: - Override
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group("auth") { builder in
            builder.post("signup", use: signUp)
            builder.group(Shelter.authenticator(), Shelter.guardMiddleware()) { builder in
                builder.get("signin", use: signIn)
            }
        }
    }
    
    // MARK: - Routes
    // Creates an user (shelter) in the database and returns the access token that doesn't expire
    func signUp(req: Request) async throws -> String {
        
        // Get the shelter that tries to sign up
        var reqBody = try req.content.decode(Shelter.Create.self)
        reqBody.password = try req.password.hash(reqBody.password)
        
        // Write the shelter to the database
        let shelter = Shelter(name: reqBody.name,
                              password: reqBody.password,
                              phoneNumber: reqBody.phoneNumber,
                              type: reqBody.type,
                              address: reqBody.address)
        try await shelter.create(on: req.db)
        
        // Get the access token of the created shelter
        guard let shelterId = shelter.id else {
            throw Abort(.unprocessableEntity)
        }
        let token = JWTToken.generateTokenFor(user: shelterId)
        
        // Sign the token with the APIKey and return it
        let signedToken = try req.jwt.sign(token)
        return signedToken
    }
    
    func signIn(req: Request) async throws -> String {
        
        // Get shelter that is signing in
        let shelter = try req.auth.require(Shelter.self)
        
        // Get the access token of the created shelter
        guard let shelterId = shelter.id else {
            throw Abort(.unprocessableEntity)
        }
        let token = JWTToken.generateTokenFor(user: shelterId)
        
        // Sign the token with the APIKey and return it
        let signedToken = try req.jwt.sign(token)
        return signedToken
    }
}
