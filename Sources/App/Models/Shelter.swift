//
//  File.swift
//  
//
//  Created by Ismael Sabri Pérez on 1/2/23.
//

import Vapor
import Fluent

/**
 Shelter model identified by an UUID id
 */
final class Shelter: Model, Content {
    
    /**
     Name of the table that will store the shelters in the database
     */
    static var schema = "shelters"
    
    //Properties
    /**
     The id of the shelter that represents the primary key of the shelter
     */
    @ID(key: .id)
    var id: UUID?
    /**
     The name of the shelter that can not be repeated in the database
     */
    @Field(key: "name")
    var name: String
    /**
     The password used for a shelter to login to the app
     */
    @Field(key: "password")
    var password: String
    /*
     The phone number of the shelter
     */
    @Field(key: "phoneNumber")
    var phoneNumber: String
    /**
     The address of the shelter
     
     The address is given in latitude and longitude
     */
    @Group(key: "address")
    var address: Address
    /**
     The shelter type
     */
    @Enum(key: "shelterType")
    var shelterType: ShelterType
    /**
     The photo url that contains the profile picture of a shelter
     */
    @OptionalField(key: "photoURL")
    var photoURL: String?
    
    // Inits
    init() {}
    
    /**
     Sets the initial value of all the properties of a shelter
     - Parameter id: The id of the shelter that represents the primary key of the shelter
     - Parameter name: Name of the table that will store the shelters in the database
     - Parameter password: The password used for a shelter to login to the app
     - Parameter phoneNumber: The phone number of the shelter
     - Parameter address: The address of the shelter
     - Parameter shelterType: The shelter type
     - Parameter photoURL: The photo url that contains the profile picture of a shelter
     */
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

// MARK: - Shelter Data Transfer Objects
extension Shelter {
    /**
     Shelter DTO model used when creating a shelter account
     */
    struct Create: Content {
        let name: String
        var password: String
        let phoneNumber: String
        let address: Address
        let shelterType: ShelterType
        var photoURL: String?
    }
    /**
     Shelter DTO model used when logging in
     */
    struct SignIn: Content {
        let name: String
        let password: String
    }
    /**
     Shelter DTO model  that contains the info to be showed on map when requested by an user
     */
    struct Map: Content {
        let id: UUID
        let name: String
        let phoneNumber: String
        let address: Address
        let shelterType: ShelterType
        var photoURL: String?
    }
}

// MARK: - Model Authenticable
extension Shelter: ModelAuthenticatable {
    
    static var usernameKey = \Shelter.$name
    static var passwordHashKey = \Shelter.$password
    
    /**
     Verifies that the given password matches the encrypted version stored in the database
     - Parameter password: The password of the shelter
     */
    func verify(password: String) throws -> Bool {
        return try Bcrypt.verify(password, created: self.password)
    }
}
