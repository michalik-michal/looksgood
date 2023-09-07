import SwiftUI

extension Image {
    enum SFSymbol: String {
        case bell
        case person
        case globe
        case house
        case envelope
        case infoCircle = "info.circle"
        case plus
        case starFill = "star.fill"
        case map
        case chevronLeft = "chevron.left"
        case xmark
        case eye
        case eyeSlash = "eye.slash"
        case trash
        case phone
        case book
        case squareStack3dUp = "square.stack.3d.up"
        case magnifyingGlass = "magnifyingglass"
    }
    
    init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
