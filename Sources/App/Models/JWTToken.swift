
import Vapor
import JWT


struct JWTToken: Content, JWTPayload, Authenticatable {
    
    // MARK: - Properties
    var iss: IssuerClaim
    var sub: SubjectClaim
    
    // MARK: - JWTPayload
    func verify(using signer: JWTSigner) throws {
        
        // Make sure that only the app defined under APP_BUNDLE_ID in the .env file access this server
        guard iss.value == Environment.process.APP_BUNDLE_ID else {
            throw JWTError.claimVerificationFailure(name: "Issuer Claim", reason: "Issuer is not valid")
        }
        
        // Subject must be an UUID convertible object
        guard let _ = UUID(sub.value) else {
            throw JWTError.claimVerificationFailure(name: "Subject Claim", reason: "Subject ID is not valid")
        }
    }
    
    // Generates a token without expiration time for an user with id userId
    static func generateTokenFor(user userId: UUID) -> JWTToken {
        return JWTToken(iss: .init(value: Environment.process.APP_BUNDLE_ID!), sub: .init(value: userId.uuidString))
    }
}
