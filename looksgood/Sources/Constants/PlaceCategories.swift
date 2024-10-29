import SwiftUI

class PlaceCategories {

    let placeCategories: [PlaceCategory] = [
        PlaceCategory(type: .salaZabaw),
        PlaceCategory(type: .taniec),
        PlaceCategory(type: .warsztatyEdukacyjne),
        PlaceCategory(type: .warsztatyMuzyczne),
    ]
    
    func colorProvider(_ item: PlaceCategoriesEnum) -> Color {
        switch item {
        case .salaZabaw:
            return Color.red
        case .taniec:
            return Color.blue
        case .warsztatyEdukacyjne:
            return Color.orange
        case .warsztatyMuzyczne:
            return Color.pink
        }
    }
}
