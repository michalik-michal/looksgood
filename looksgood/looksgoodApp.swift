import SwiftUI
import Firebase

@main
struct looksgoodApp: App {

    @StateObject private var authPublisher = AuthPublisher()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authPublisher)
        }
    }
}
