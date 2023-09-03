import Foundation

struct PlaceCategory: Hashable {
    var category: String = ""
    var image: String = ""
    var type: PlaceCategoriesEnum
    
    init(type: PlaceCategoriesEnum) {
        self.type = type
        self.category = getCategoryName(type)
        self.image = getCategoryImage(type)
    }
    
    func getCategoryName(_ category: PlaceCategoriesEnum) -> String {
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
    
    func getCategoryImage(_ category: PlaceCategoriesEnum) -> String {
        switch category {
        case .cafe:
            return "cup.and.saucer"
        case .foodTruck:
            return "box.truck"
        case .restaurant:
            return "fork.knife"
        case .breakfast:
            return "sun.max"
        case .vege:
            return "leaf"
        case .drinks:
            return "wineglass"
        }
    }
}
