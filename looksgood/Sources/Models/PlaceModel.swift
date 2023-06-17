import Foundation

struct Place: Equatable, Identifiable, Decodable {
    var id: String?
    var name: String
    var address: String?
    var googleMapsURL: String?
    var googleMapsID: String?
    var long: String?
    var lat: String?
    var rating: String?
    var phoneNumber: String?
    var website: String?
    var openingHours: [String]?
    var placeCategory: PlaceCategoriesEnum
}
