import Vapor

final class APIKeyMiddleware: AsyncMiddleware {
    
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
