
import Vapor
import Fluent

// A point on the map represented by the latitude and longitude
final class Address: Fields {
    
    // Properties
    @Field(key: "latitude")
    var latitude: Double

    // The longitude
    @Field(key: "longitude")
    var longitude: Double

    // Initializers
    init() { }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}


