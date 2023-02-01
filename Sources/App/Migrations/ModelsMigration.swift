
import Vapor
import Fluent

struct ModelsMigration: AsyncMigration {
    
    func prepare(on database: FluentKit.Database) async throws {
        
        // Create the model Shelter in the database
        try await database
            .schema(Shelter.schema)
            .id()
            .field("name", .string, .required)
            .field("password", .string, .required)
            .field("phoneNumber", .string, .required)
            .field("type", .string, .required)
            .field("address", .string, .required)
            .field("imageURL", .string)
            .unique(on: "name")
            .create()
        
        // Populate the database with fake models in production
        #if DEBUG
            let shelterParticular1 = Shelter(name: "particular1", password: "123", phoneNumber: "44433421", type: "Particular", address: "particularaddress")
            let shelterParticular2 = Shelter(name: "particular2", password: "123", phoneNumber: "44433421", type: "Particular", address: "particularaddress")
            let shelterParticular3 = Shelter(name: "particular3", password: "123", phoneNumber: "44433421", type: "Particular", address: "particularaddress")
            let shelterVeterinary = Shelter(name: "vet", password: "123", phoneNumber: "44433421", type: "Particular", address: "particularaddress")
            try await [shelterParticular1, shelterParticular2, shelterParticular3, shelterVeterinary].create(on: database)
        #else
        #endif
        
    }
    
    func revert(on database: Database) async throws {
        try await Shelter.query(on: database).delete()
        try await database.schema(Shelter.schema).delete()
    }
    
}
