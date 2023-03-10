
import Vapor
import Fluent

/**
 A point on the map represented by the latitude and longitude
 */
final class Address: Fields {
    
    // Properties
    /**
     The latitude of the address given in coordinates
     */
    @Field(key: "latitude")
    var latitude: Double

    /**
     The longitude of the address given in coordinates
     */
    @Field(key: "longitude")
    var longitude: Double

    // Initializers
    init() { }
    
    /**
     Creates a new Address object setting the latitude and longitude
     */
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}


