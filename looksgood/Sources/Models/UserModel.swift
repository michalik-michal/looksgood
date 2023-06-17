import Foundation

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var username: String
    var accountType: AccountType
    var places: String?
}
