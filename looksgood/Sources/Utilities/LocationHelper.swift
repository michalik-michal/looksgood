import Foundation
import CoreLocation

final class LocationHelper {
    
    func getCoordinates(from address: String) async -> [String: String] {
        var location = [
            "lat": "",
            "long": ""
        ]
        let geocoder = CLGeocoder()
        do {
            let placemark = try await geocoder.geocodeAddressString(address)
            let lat = placemark.first?.location?.coordinate.latitude
            let long = placemark.first?.location?.coordinate.longitude
            location.updateValue(lat?.debugDescription ?? "", forKey: "lat")
            location.updateValue(long?.debugDescription ?? "", forKey: "long")
        } catch {
            print("DEBUG: Failed to extract location from address \(error)")
        }
        return location
    }
}
