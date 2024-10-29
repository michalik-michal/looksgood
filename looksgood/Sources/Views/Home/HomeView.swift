import MapKit
import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    @State private var tappedMarker: CustomMarker?
    @State private var showPlaceSheet = false
    @State private var showListView = false
    @State private var showDealsView = false
    @State private var showProfileView = false
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
                    profileIcon
                 //   dealsIcon
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
                .fullScreenCover(isPresented: $showProfileView) {
                    NavigationModalBarView(showModal: $showProfileView, content: ProfileView())
                }
            }
        }
    }

    private var listButton: some View {
        HStack {
            Image(.squareStack3dUp)
            Text("Lista")
        }
        .padding()
        .frame(width: 100, height: 40)
        .background(Color.whiteBlack)
        .cornerRadius(15)
        .onTapGesture {
            showListView.toggle()
        }
        .shadow(color: Color.blackWhite, radius: 1)
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
    
    private var profileIcon: some View {
        HStack {
            Spacer()
            ZStack {
                Circle()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.whiteBlack)
                    .shadow(color: Color.blackWhite, radius: 1)
                Image(.person)
                    .frame(width: 45, height: 45)
                    .foregroundColor(.blackWhite)
                    .onTapGesture {
                        showProfileView.toggle()
                    }
            }
            .padding(.top, 5)
            .onTapGesture {
                showDealsView.toggle()
            }
        }
        .overlay {
            Image("parently")
                .resizable()
                .frame(width: 130, height: 50)
                .cornerRadius(20)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
