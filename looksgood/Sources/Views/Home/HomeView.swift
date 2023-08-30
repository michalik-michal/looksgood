import MapKit
import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    @State private var tappedMarker: CustomMarker?
    @State private var showPlaceSheet = false
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var placeService: PlaceService
    
    var body: some View {
        if placeService.markers.isEmpty {
            ProgressView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        Task {
                            try await placeService.fetchPlaces()
                        }
                    }
                }
        } else {
            ZStack {
                VStack {
                    GoogleMapsView(tappedMarker: $tappedMarker)
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
                .onChange(of: tappedMarker) { marker in
                    if marker != nil {
                        showPlaceSheet.toggle()
                    }
                }
                .sheet(isPresented: $showPlaceSheet) {
                    if let marker = tappedMarker {
                        PlaceView(placeID: marker.id)
                            .onDisappear {
                                tappedMarker = nil
                            }
                            .presentationDetents([.medium])
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
