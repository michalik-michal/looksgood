import MapKit
import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    @State private var tappedMarker: CustomMarker?
    @State private var showPlaceSheet = false
    @State private var showListView = false
    @State private var showDealsView = false
    @EnvironmentObject private var locationManager: LocationService
    @EnvironmentObject private var placeService: PlaceService
    
    var body: some View {
        if placeService.markers.isEmpty {
            ProgressView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        Task {
                            try await placeService.fetchMarkers()
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
                    dealsIcon
                    Spacer()
                    listButton
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
                .fullScreenCover(isPresented: $showListView) {
                    NavigationModalBarView(showModal: $showListView,
                                           content: PlaceListView())
                }
                .fullScreenCover(isPresented: $showDealsView) {
                    NavigationModalBarView(showModal: $showDealsView,
                                           content: DealsView())
                }
            }
        }
    }

    private var listButton: some View {
        HStack {
            Image(.squareStack3dUp)
            Text(Strings.list)
        }
        .padding()
        .frame(width: 100, height: 40)
        .background(Color.whiteBlack)
        .cornerRadius(15)
        .onTapGesture {
            showListView.toggle()
        }
        .shadow(color: Color.black.opacity(0.3), radius: 20, y: 5)
    }
    
    private var dealsIcon: some View {
        HStack {
            Spacer()
            ZStack {
                Circle()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.whiteBlack)
                Image(systemName: "gift.circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.green)
            }
            .padding(.top, 5)
            .onTapGesture {
                showDealsView.toggle()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
