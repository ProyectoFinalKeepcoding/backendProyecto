import Vapor

/**
 The middleware applied to protect a route under the api key
 */
final class APIKeyMiddleware: AsyncMiddleware {
    
    /**
     Gets a response for a given request containing or not the api key
     
     - Parameter request: The request to which the function will respond
     - Parameter next:The natural follower of the response chain
     - Throws: A bad request error if the api key header is missing
     - Throws: A failed dependency error if the api key can not be obtained from the .env file in which the api key is declared
     - Throws: An unauthorized error if the api key of the request does not match the .env file api key
     */
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        
        // Get API Key from the user request
        guard let apiKey = request.headers.first(name: "ApiKey") else {
            throw Abort(.badRequest, reason: "ApiKey header is missing.")
        }
        
        // Get API from the environment file
        guard let envApiKey = Environment.process.API_KEY else {
            throw Abort(.failedDependency)
        }
        
        // If the user provided ApiKey doesn't match the environment file ApiKey -> abort operation
        guard apiKey == envApiKey else {
            throw Abort(.unauthorized, reason: "Invalid API Key")
        }
        
        return try await next.respond(to: request)
        
    }
    
}
