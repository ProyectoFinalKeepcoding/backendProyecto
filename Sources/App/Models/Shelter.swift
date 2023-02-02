//
//  File.swift
//  
//
//  Created by Ismael Sabri Pérez on 1/2/23.
//

import Vapor
import Fluent

final class Shelter: Model, Content {
    
    // Name of the table in the database
    static var schema = "shelters"
    
    //Properties
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "phoneNumber")
    var phoneNumber: String
    
    @Group(key: "address")
    var address: Address
    
    @Enum(key: "shelterType")
    var shelterType: ShelterType
    
    @OptionalField(key: "imageURL")
    var photoURL: String?
    
    // Inits
    init() {}
    
    internal init(id: UUID? = nil, name: String, password: String, phoneNumber: String, address: Address, shelterType: ShelterType, photoURL: String? = nil) {
        self.id = id
        self.name = name
        self.password = password
        self.phoneNumber = phoneNumber
        self.address = address
        self.shelterType = shelterType
        self.photoURL = photoURL
    }
}

// MARK: - Shelter DTO's
extension Shelter {
    // DTO used to create a shelter user
    struct Create: Content {
        let name: String
        var password: String
        let phoneNumber: String
        let address: Address
        let shelterType: ShelterType
    }
    //DTO used to sign in
    struct SignIn: Content {
        let name: String
        let password: String
    }
    // DTO that contains the info to be showed on map when requested by an user
    struct Map: Content {
        let id: UUID
        let name: String
        let phoneNumber: String
        let address: Address
        let shelterType: ShelterType
    }
}

// MARK: - Model Authenticable
extension Shelter: ModelAuthenticatable {
    
    static var usernameKey = \Shelter.$name
    static var passwordHashKey = \Shelter.$password
    
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.password)
    }
}
