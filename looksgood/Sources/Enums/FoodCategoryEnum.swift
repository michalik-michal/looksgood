import Foundation

enum FoodCategory: String, CaseIterable, Codable, Comparable {
    static func < (lhs: FoodCategory, rhs: FoodCategory) -> Bool {
        if lhs == .All || rhs == .All {
            return false
        } else {
            return lhs.rawValue < rhs.rawValue
        }
    }
    
    case Pizza
    case Burger
    case Vege
    case Breakfast
    case Drinks
    case Alcohol
    case Lunch
    case Desert
    case All
    case specialOffer = "Special Offer"
}
