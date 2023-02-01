
import Vapor

struct TestController: RouteCollection {
    
    // MARK: - Override
    func boot(routes: RoutesBuilder) throws {
        routes.get("test", use: test)
    }
    
    // MARK: - Routes
    func test(req: Request) async throws -> String {
        return "This is a test!"
    }
    
}
