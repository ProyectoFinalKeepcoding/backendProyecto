import Fluent
import Vapor

func routes(_ app: Application) throws {

    try app.group("api") { builder in
        // Registered endpoints with the protection of the APIKey
        try builder.group(APIKeyMiddleware()) { builder in
            try builder.register(collection: TestController())
            try builder.register(collection: AuthController())
            try builder.register(collection: ShelterController())
            try builder.register(collection: ImageUploadController())
        }
    }
}
