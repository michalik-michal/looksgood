import Foundation

final class CategoryNameConverter {
    func convertCategory(_ category: PlaceCategoriesEnum) -> String {
        switch category {
        case .cafe:
            return "Cafe"
        case .foodTruck:
            return "Food Truck"
        case .restaurant:
            return "Restaurant"
        case .breakfast:
            return "Breakfast"
        case .vege:
            return "Vege"
        case .drinks:
            return "Drinks"
        }
    }
}
