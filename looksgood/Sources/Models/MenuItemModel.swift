import Foundation
import Firebase
import FirebaseFirestoreSwift

struct MenuItem: Codable, Hashable {

    @DocumentID var id: String?

    var placeID: String
    var title: String
    var price: String
    var category: FoodCategory
    var description: String?
    var imageURL: String?
    var ingredients: [String]?
}
