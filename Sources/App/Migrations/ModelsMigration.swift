
import Vapor
import Fluent

struct ModelsMigration: AsyncMigration {
    
    func prepare(on database: FluentKit.Database) async throws {
        
        // Create enum shelterType
        let shelterType = try await database.enum("shelterType")
            .case("veterinary")
            .case("particular")
            .case("shelterPoint")
            .case("localGovernment")
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
        let shelterParticular1 = Shelter(name: "Fran", password: "123", phoneNumber: "44433421", address: Address(latitude: 39.865762, longitude: -4.030329), shelterType: .particular)
            let shelterParticular2 = Shelter(name: "Isma", password: "123", phoneNumber: "44433421", address: Address(latitude: 40.405775, longitude: -3.996504), shelterType: .particular)
            let shelterParticular3 = Shelter(name: "Joakin", password: "123", phoneNumber: "44433421", address: Address(latitude: 40.422989, longitude: -3.637153), shelterType: .particular)
        let shelterVeterinary = Shelter(name: "Aitor", password: "123", phoneNumber: "44433421", address: Address(latitude: 43.262217, longitude: -2.872610), shelterType: .veterinary)
        let localGovernment = Shelter(name: "Robert", password: "123", phoneNumber: "44433421", address: Address(latitude: 43.229454, longitude: -3.205004), shelterType: .localGovernment)
            try await [shelterParticular1, shelterParticular2, shelterParticular3, shelterVeterinary, localGovernment].create(on: database)
        #else
        #endif
        
    }
    
    func revert(on database: Database) async throws {
        try await Shelter.query(on: database).delete()
        try await database.schema(Shelter.schema).delete()
        try await database.enum("shelterType").delete()
    }
    
}
