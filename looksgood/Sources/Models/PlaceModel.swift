import Foundation

struct Place: Equatable {
    var id: String?
    var name: String
    var secondaryName: String?
    var address: String?
    var googleMapsURL: String?
    var long: String?
    var lat: String?
    var rating: String?
    var phoneNumber: String?
    var website: String?
    var openingHours: [String]?
}
