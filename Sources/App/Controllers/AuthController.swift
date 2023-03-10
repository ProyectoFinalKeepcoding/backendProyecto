
import Vapor
import Fluent

/**
 Collection of routes used to authenticate shelters
 */
struct AuthController: RouteCollection {

    // MARK: - Override
    /**
     Sets up the authentication routes signup and sign in under the auth path
     
     - Parameter routes: The routes builder
     */
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group("auth") { builder in
            builder.post("signup", use: signUp)
            builder.group(Shelter.authenticator(), Shelter.guardMiddleware()) { builder in
                builder.get("signin", use: signIn)
            }
        }
    }
    
    // MARK: - Routes
    /**
     Creates a shelter  in the database shelter table and returns an access token that doesn't expire
     
     - Parameter req: The request of the sign up call
     - Throws Unprocessable entity error if the shelter id is null
     - Returns: A string token that is signed by the shelter
     
     */
    func signUp(req: Request) async throws -> String {
        
        // Get the shelter that tries to sign up
        var reqBody = try req.content.decode(Shelter.Create.self)
        reqBody.password = try req.password.hash(reqBody.password)
        
        // Write the shelter to the database
        let shelter = Shelter(name: reqBody.name,
                              password: reqBody.password,
                              phoneNumber: reqBody.phoneNumber,
                              address: reqBody.address,
                              shelterType: reqBody.shelterType)
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
    /**
     Verifies that a shelter is registered in the database and matches the encrypted password
     
     - Parameter req: The request of the sign in call
     - Throws Unprocessable entity error if the shelter id is null
     - Returns: An array of string whose first element is the token and the second element is the id of the shelter
     
     */
    func signIn(req: Request) async throws -> [String] {
        
        // Get shelter that is signing in
        let shelter = try req.auth.require(Shelter.self)
        
        // Get the access token of the created shelter
        guard let shelterId = shelter.id else {
            throw Abort(.unprocessableEntity)
        }
        let token = JWTToken.generateTokenFor(user: shelterId)
        
        // Sign the token with the APIKey and return it
        let signedToken = try req.jwt.sign(token)
        return [signedToken, shelterId.uuidString]
    }
}
