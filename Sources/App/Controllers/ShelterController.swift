
import Vapor
import Fluent

/**
 Collection of routes to manage shelters
 */
struct ShelterController: RouteCollection {
    
    // MARK: - Override
    /**
     Sets up the routes to manage shelters in the server
     
     - Parameter routes: The routes builder
     */
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.get("shelters", use: allShelters)
        routes.get("shelters", ":id", use: shelter)
        // The update shelter endpoint is protected by token
        routes.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
            builder.post("update", ":id", use: updateShelter)
        }
    }
    
    // MARK: - Routes
    /**
     Gets all shelters from the database and maps them to shelters to be shown to the user on map
     - Parameter req: The request of the call
     - Returns: A list of shelter to be shown to the user on map
     */
    func allShelters(req: Request) async throws -> [Shelter.Map] {
        try await Shelter.query(on: req.db).all().map { dbShelter in
            try Shelter.Map(id: dbShelter.requireID(), name: dbShelter.name, phoneNumber: dbShelter.phoneNumber, address: dbShelter.address, shelterType: dbShelter.shelterType, photoURL: dbShelter.photoURL)
        }
    }
    
    /**
     Gets a shelter by id and map it to be shown to the user on map
     - Parameter req: The request of the call
     - Returns: A shelter to be shown to the user on a map
     */
    func shelter(req: Request) async throws -> Shelter.Map {
        
        // Get the name from the parameters of the request
        let id = req.parameters.get("id", as: UUID.self)
        
        // Get the shelter matching the name on the db
        guard let shelter = try await Shelter.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        // Return the shelter ready to be shown
        return try Shelter.Map(id: shelter.requireID(), name: shelter.name, phoneNumber: shelter.phoneNumber, address: shelter.address, shelterType: shelter.shelterType, photoURL: shelter.photoURL)
    }
    
    /**
     Updates a shelter by id
     - Parameter req: The request of the call
     - Throws: A not found abort error if the shelter is not found in the database
     - Returns: The updated shelter
     */
    
    func updateShelter(req: Request) async throws -> Shelter {
        // Get the name from the parameters of the request
        let id = req.parameters.get("id", as: UUID.self)
        // Get the shelter matching the name on the db
        guard let shelter = try await Shelter.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        // Get the body of the request as a shelter
        let reqBody = try req.content.decode(Shelter.Create.self)
        // Update the shelter with the new values (only detail values)
        shelter.name = reqBody.name
        shelter.photoURL = reqBody.photoURL
        shelter.address = reqBody.address
        shelter.phoneNumber = reqBody.phoneNumber
        shelter.shelterType = reqBody.shelterType
        // Write the shelter to the database
        try await shelter.update(on: req.db)
        // Return the updated shelter
        return shelter
    }
}
