import SwiftUI
import Firebase
import GoogleMaps
import GooglePlaces

@main
struct looksgoodApp: App {

    @StateObject private var authService = AuthService()
    @StateObject private var locationManager = LocationManager()
    
    init() {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyCJ-NFArV0Xw3V07WJguOwaZZR32WqUyGg")
        GMSPlacesClient.provideAPIKey("AIzaSyCJ-NFArV0Xw3V07WJguOwaZZR32WqUyGg")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService)
                .environmentObject(locationManager)
        }
    }
}
