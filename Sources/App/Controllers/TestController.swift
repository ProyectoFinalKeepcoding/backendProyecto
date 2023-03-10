
import Vapor

/**
 Collection of routes to test server configuration
 */
struct TestController: RouteCollection {
    
    // MARK: - Override
    /**
     Sets up the routes to test valid server configuration
     
     - Parameter routes: The routes builder
     */
    func boot(routes: RoutesBuilder) throws {
        routes.get("test", use: test)
    }
    
    // MARK: - Routes
    /**
     Tests the server configuration
     
     - Parameter req: The request of the call
     - Returns: The string "This is a test!" if the test is successful
     */
    func test(req: Request) async throws -> String {
        return "This is a test!"
    }
    
}
