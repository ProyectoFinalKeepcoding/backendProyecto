
import Vapor
import Fluent

struct ShelterController: RouteCollection {
    
    // MARK: - Override
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.get("shelters", use: allShelters)
        routes.get("shelters", ":id", use: shelter)
    }
    
    // MARK: - Routes
    // Gets all shelters from the database and maps them to shelters to be shown to the user on map
    func allShelters(req: Request) async throws -> [Shelter.Map] {
        try await Shelter.query(on: req.db).all().map { dbShelter in
            try Shelter.Map(id: dbShelter.requireID(), name: dbShelter.name, phoneNumber: dbShelter.phoneNumber, address: dbShelter.address, shelterType: dbShelter.shelterType, photoURL: dbShelter.photoURL)
        }
    }
    // Gets one shelter by id and map it to be shown to the user on map
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
}
