import SwiftUI

class RegisterPublisher: ObservableObject {

    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    
    
    func convertUserType(_ accountType: AccountType) -> String {
        switch accountType {
        case .user:
            return Strings.user
        case .restaurantOwner:
            return Strings.restaurantOwner
        }
    }
}
