import Fluent
import Vapor

/**
Registers all the routes for the application.

Be aware that all the routes are registered under the /api path, which means that all of them will be 
protected by the api key.

- Parameter app: The application to register the routes for.
- Throws: Any error that occurs during the registration of the routes.
*/
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
