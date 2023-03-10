
import Vapor
import Fluent

/**
Version control of the models in the database
 */
struct ModelsMigration: AsyncMigration {
    
    /**
     Sets up the objects, tables and relations of the database
     - Parameter database: The database where the objects, tables and relations will be created in
     */
    func prepare(on database: FluentKit.Database) async throws {
        
        // Create enum shelterType
        let shelterType = try await database.enum("shelterType")
            .case("veterinary")
            .case("particular")
            .case("shelterPoint")
            .case("localGovernment")
            .case("kiwokoStore")
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
        let kiwokoStore1 = Shelter(name: "KiwokoStore1", password: "123", phoneNumber: "23423242112454232", address: Address(latitude: 40.4410353, longitude: -3.9992455), shelterType: .kiwokoStore)
        let kiwokoStore2 = Shelter(name: "KiwokoStore2", password: "123", phoneNumber: "918167789", address: Address(latitude: 40.45283915, longitude: -3.8682917800496277), shelterType: .kiwokoStore)
        let kiwokoStore3 = Shelter(name: "KiwokoStore3", password: "123", phoneNumber: "918167787", address: Address(latitude: 40.3446868, longitude: -3.8486131), shelterType: .kiwokoStore)
        let shelterVeterinary2 = Shelter(name: "VeterinarySevillaLaNuevaWithLongName", password: "123", phoneNumber: "666909898", address: Address(latitude: 40.3475422, longitude: -4.0275268), shelterType: .veterinary)

            try await [shelterParticular1, shelterParticular2, shelterParticular3, shelterVeterinary, localGovernment, kiwokoStore1, kiwokoStore2, kiwokoStore3, shelterVeterinary2].create(on: database)
        #else
        #endif
        
    }
    
    /**
     Reverts the effects of the prepare function
     - Parameter database: The database object of reversion
     */
    func revert(on database: Database) async throws {
        try await Shelter.query(on: database).delete()
        try await database.schema(Shelter.schema).delete()
        try await database.enum("shelterType").delete()
    }
    
}
