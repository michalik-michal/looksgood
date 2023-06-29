import Foundation

struct MenuItem: Codable, Hashable {
    var placeID: String
    var title: String
    var price: String
    var category: FoodCategory
    var description: String?
    var imageURL: String?
    var ingredients: [String]?
}
