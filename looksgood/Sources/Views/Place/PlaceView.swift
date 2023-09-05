import SwiftUI

struct PlaceView: View {
    
    @EnvironmentObject private var placeService: PlaceService
    @EnvironmentObject private var locationManager: LocationService
    var placeID: String
    @State private var place = Place(name: "", placeCategory: .restaurant)
    @State private var showMenu = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if let imageURL = place.imageURL, imageURL.isNotEmptyString {
                    asyncImage(url: imageURL)
                }
                VStack {
                    titleStack
                        .padding(.top, place.imageURL == "" ? 10 : 0)
                    adressStack
                    secondaryStack
                    buttonStack
                        .padding(.bottom, 10)
                    PlainLabel(title: "Menu",
                               image: Image(.book))
                    .onTapGesture {
                        showMenu.toggle()
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .fullScreenCover(isPresented: $showMenu) {
            NavigationModalBarView(showModal: $showMenu,
                                   content: MenuView(placeID: placeID))
        }
        .onAppear {
            Task {
                if let fetchedPlace = try await placeService.fetchPlace(with: placeID) {
                    place = fetchedPlace
                }
            }
        }
    }
    
    private func asyncImage(url: String) -> some View {
        return AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .frame(height: 180)
        } placeholder: {
            ProgressView()
                .frame(width: UIScreen.main.bounds.width,
                       height: 180)
        }
    }

    private var titleStack: some View {
        HStack {
            Text(place.name)
                .font(.title.bold())
                .foregroundColor(.blackWhite)
            Spacer()
        }
    }

    private var adressStack: some View {
        HStack {
            Text(place.address ?? "")
                .foregroundColor(.gray)
            Spacer()
        }
    }

    private var secondaryStack: some View {
        HStack {
            PlaceCategoryCell(placeCategory: PlaceCategory(type: place.placeCategory))
            Spacer()
            Text("10:00 - 23:00")
                .foregroundColor(.gray)
                .bold()
        }
        .padding(.bottom)
    }

    private var buttonStack: some View {
        HStack {
            HStack {
                Image("googlemaps")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Navigate")
            }
            .onTapGesture {
                if let destinationLat = Double(place.lat ?? ""), let destinationLong = Double(place.long ?? "") {
                    GoogleMapsService.shared.navigateOnGoogleMap(sourceLatitude: locationManager.latitude,
                                                                 sourceLongitude: locationManager.longitude,
                                                                 destinationLatitude: destinationLat,
                                                                 destinationLongitude: destinationLong)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blackWhite, lineWidth: 1))
            if let phone = place.phoneNumber, phone.isNotEmptyString {
                Link(destination: URL(string: "tel://\(phone.filter{!$0.isWhitespace})")!, label: {
                    HStack {
                        Image(systemName: "iphone")
                        Text("Call")
                    }
                })
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blackWhite, lineWidth: 1))
            }
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(placeID: "")
            .environmentObject(PlaceService())
    }
}
