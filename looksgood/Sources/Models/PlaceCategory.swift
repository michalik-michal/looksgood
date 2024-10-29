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
        case .salaZabaw:
            return "Sale Zabaw"
        case .taniec:
            return "Taniec"
        case .warsztatyEdukacyjne:
            return "Warsztaty Edukacyjne"
        case .warsztatyMuzyczne:
            return "Warsztaty Muzyczne"
        }
    }
    
    func getCategoryImage(_ category: PlaceCategoriesEnum) -> String {
        switch category {
        case .salaZabaw:
            return "batteryblock"
        case .taniec:
            return "figure.dance"
        case .warsztatyEdukacyjne:
            return "lightbulb.min"
        case .warsztatyMuzyczne:
            return "music.mic"
        }
    }
}
