
import Vapor
import Fluent

struct ImageUploadController: RouteCollection {
    
    // MARK: - Override
    func boot(routes: Vapor.RoutesBuilder) throws {
        routes.group(JWTToken.authenticator(), JWTToken.guardMiddleware()) { builder in
            builder.post("upload", ":id", use: upload)
        }
    }
    
    // MARK: - Routes
    // Uploads a picture to the server into the public folder with a name depending on the id of the shelter
    func upload(_ req: Request) throws -> EventLoopFuture<Response> {
        // Decode the photo uploaded as a byte array in the response to the ImageUploadData struct
        let data = try req.content.decode(ImageUploadData.self)
        // Get the shelter from the id parameter of the request
        return Shelter.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { shelter in
                // Get the shelter id or throw an error otherwise
                let shelterId: UUID
                do {
                    shelterId = try shelter.requireID()
                } catch {
                    return req.eventLoop.future(error: error)
                }
                // Create a name for the profile picture
                let profilePictureName = "\(shelterId).png"
                // The path where the picture will be saved is the public directory + the profile picture name
                let path = req.application.directory.publicDirectory + profilePictureName
                //
                return req.fileio
                    .writeFile(.init(data: data.picture), at: path)
                    .flatMap {
                        // Assign the created profile picture name to the photo url of the shelter
                        shelter.photoURL = profilePictureName
                        // Save the shelter and redirect it to the shelters page
                        let redirect = req.redirect(to: "/api/shelters/\(shelterId)")
                        return shelter.save(on: req.db).transform(to: redirect)
                    }
            }
    }
}

struct ImageUploadData: Content {
  var picture: Data
}
