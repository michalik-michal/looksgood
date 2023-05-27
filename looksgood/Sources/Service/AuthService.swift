import Foundation
import Firebase
import FirebaseFirestoreSwift

// Main Actor publishes changes on the main thread
@MainActor
class AuthService: ObservableObject {

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var didRegisterUSer = false
    @Published var didLogOutUser = false
    @Published var didDeleteUser = false

    init() {
        self.userSession = Auth.auth().currentUser
        Task { await fetchUser() }
    }
    
    func logIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func register(email: String, password: String, username: String, accountType: AccountType) async throws {
        do {
            // Try Await - Waits fot thre result
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email, username: username, accountType: accountType)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    //TODO Handle error
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    func deleteAccount(uid: String) async {
        if let user = Auth.auth().currentUser {
            Task {
                do {
                    try await user.delete()
                } catch {
                    print("Error deleting user \(error.localizedDescription)")
                }
            }
        }
        Task { try? await Firestore.firestore().collection("users").document(uid).delete() }
        userSession = nil
        currentUser = nil
    }
}
