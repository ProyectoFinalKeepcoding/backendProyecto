
import Vapor
import Fluent

struct ModelsMigration: AsyncMigration {
    
    func prepare(on database: FluentKit.Database) async throws {
        
        // Create enum shelterType
        let shelterType = try await database.enum("shelterType")
            .case("veterinary")
            .case("particular")
            .case("shelterPoint")
            .create()
        
        // Create the model Shelter in the database
        try await database
            .schema(Shelter.schema)
            .id()
            .field("name", .string, .required)
            .field("password", .string, .required)
            .field("phoneNumber", .string, .required)
            .field("address_longitude", .double, .required)
            .field("address_latitude", .double, .required)
            .field("shelterType", shelterType, .required)
            .field("photoURL", .string)
            .unique(on: "name")
            .create()
        
        // Populate the database with fake models in production
        #if DEBUG
        let shelterParticular1 = Shelter(name: "particular1", password: "123", phoneNumber: "44433421", address: Address(latitude: 2, longitude: 2), shelterType: .particular)
            let shelterParticular2 = Shelter(name: "particular2", password: "123", phoneNumber: "44433421", address: Address(latitude: 3, longitude: 3), shelterType: .particular)
            let shelterParticular3 = Shelter(name: "particular3", password: "123", phoneNumber: "44433421", address: Address(latitude: 3, longitude: 2), shelterType: .particular)
        let shelterVeterinary = Shelter(name: "vet", password: "123", phoneNumber: "44433421", address: Address(latitude: 1, longitude: 4), shelterType: .veterinary)
            try await [shelterParticular1, shelterParticular2, shelterParticular3, shelterVeterinary].create(on: database)
        #else
        #endif
        
    }
    
    func revert(on database: Database) async throws {
        try await Shelter.query(on: database).delete()
        try await database.schema(Shelter.schema).delete()
        try await database.enum("shelterType").delete()
    }
    
}
