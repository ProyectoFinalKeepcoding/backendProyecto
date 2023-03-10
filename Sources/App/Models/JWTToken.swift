
import Vapor
import JWT

/**
 Jason Web Token model
 */
struct JWTToken: Content, JWTPayload, Authenticatable {
    
    // MARK: - Properties
    var iss: IssuerClaim
    var sub: SubjectClaim
    
    // MARK: - JWTPayload
    /**
     Verifies that the signer of the JWT is valid
     - Parameter signer: The signer of the JWT
     - Throws: A claim verification failure if the signer is not calling the method from the app bundle or is not an UUID convertible object
     */
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
    
    /**
     Generates a token without expiration time for an user with id
     - Parameter userId:The user id
     */
    static func generateTokenFor(user userId: UUID) -> JWTToken {
        return JWTToken(iss: .init(value: Environment.process.APP_BUNDLE_ID!), sub: .init(value: userId.uuidString))
    }
}
