import SwiftUI

class PlaceCategories {
    let placeCategories: [PlaceCategory] = [
        PlaceCategory(category: "Cafe", image: "cup.and.saucer", type: .cafe),
        PlaceCategory(category: "Food Truck", image: "box.truck", type: .foodTruck),
        PlaceCategory(category: "Restaurant", image: "fork.knife", type: .restaurant),
        PlaceCategory(category: "Breakfast", image: "", type: .breakfast),
        PlaceCategory(category: "Vege", image: "", type: .vege),
        PlaceCategory(category: "Drinks", image: "wineglass", type: .drinks)
    ]
    
    func colorProvider(_ item: PlaceCategoriesEnum) -> Color {
        switch item {
        case .cafe:
            return Color.red
        case .foodTruck:
            return Color.blue
        case .restaurant:
            return Color.orange
        case .breakfast:
            return Color.pink
        case .vege:
            return Color.purple
        case .drinks:
            return Color.yellow
        }
    }
}
