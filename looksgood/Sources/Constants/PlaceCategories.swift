import SwiftUI

class PlaceCategories {

    let placeCategories: [PlaceCategory] = [
        PlaceCategory(type: .cafe),
        PlaceCategory(type: .foodTruck),
        PlaceCategory(type: .restaurant),
        PlaceCategory(type: .breakfast),
        PlaceCategory(type: .vege),
        PlaceCategory(type: .drinks)
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
