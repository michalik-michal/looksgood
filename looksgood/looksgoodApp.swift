import SwiftUI
import Firebase

@main
struct looksgoodApp: App {

    @StateObject private var authService = AuthService()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
        }
    }
}
