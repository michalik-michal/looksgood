import MapKit
import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    @EnvironmentObject private var locationManager: LocationManager
    
    var body: some View {
        ZStack {
            VStack {
                GoogleMapsView()
                    .zIndex(-10)
                    .ignoresSafeArea()
                    .onAppear {
                        locationManager.shouldUpdateLocation = false
                    }
            }
            VStack {
                MapSearchField(text: $searchText)
                Spacer()
            }
            .padding()
            .zIndex(10)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
