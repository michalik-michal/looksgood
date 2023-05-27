import Foundation

class AccountTypePublisher: ObservableObject {
    
    func convertUserType(_ accountType: AccountType) -> String {
        switch accountType {
        case .user:
            return Strings.user
        case .restaurantOwner:
            return Strings.restaurantOwner
        }
    }
    
}
