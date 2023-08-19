import SwiftUI

extension Image {
    enum SFSymbol: String {
        case bell
    }
    
    init(_ symbol: SFSymbol) {
        self.init(systemName: symbol.rawValue)
    }
}
