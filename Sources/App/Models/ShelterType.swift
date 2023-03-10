//
//  File.swift
//  
//
//  Created by Ismael Sabri Pérez on 2/2/23.
//

import Foundation

/**
Shelter type model.

The different cases summarize the types of shelters:
 
* veterinary: Shelter managed by a veterinary
* particular: Particular person who can take care of an animal temporarily
* shelterPoint: Official shelter point
* localGovernment: Local government shelter
* kiwokoStore: Kiwoko store or shelter point where animals are hosted temporarily
*/
enum ShelterType: String, Codable {
    case veterinary
    case particular
    case shelterPoint
    case localGovernment
    case kiwokoStore
}
