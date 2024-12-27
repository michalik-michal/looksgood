import SwiftUI

struct PlaceView: View {
    
    @EnvironmentObject private var placeService: PlaceService
    @EnvironmentObject private var locationManager: LocationService
    var placeID: String
    @State private var place = Place(name: "", placeCategory: .salaZabaw)
    @State private var showMenu = false
    @State private var showOpeningHours =  false
    @State private var showImages = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                //if let imageURLs = place.imageURLs, ((imageURLs.first?.isNotEmptyString) != nil) {
                    imageCarousel(urls: place.imageURLs ?? [])
              //  }
                VStack {
                    titleStack
                        .padding(.top, place.imageURLs?.first == "" ? 10 : 0)
                    adressStack
                    secondaryStack
                    categories
                    buttonStack
                        .padding(.bottom, 10)
                    PlainLabel(title: "Rezerwuj",
                               image: Image(systemName: "calendar"))
                    .onTapGesture {
                        if !showOpeningHours {
                            showMenu.toggle()
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .fullScreenCover(isPresented: $showMenu) {
            NavigationModalBarView(showModal: $showMenu,
                                   content: MenuView(placeID: placeID, place: place))
        }
        .fullScreenCover(isPresented: $showImages) {
            NavigationModalBarView(showModal: $showImages,
                                   content: ImageGridView(isOwnerView: false,
                                                          placeID: placeID))
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
                .onTapGesture {
                    showImages.toggle()
                }
        } placeholder: {
            ProgressView()
                .frame(width: UIScreen.main.bounds.width,
                       height: 180)
        }
    }
    
    private func imageCarousel(urls: [String]) -> some View {
        TabView {
            ForEach(urls, id: \.self) { url in
                AsyncImage(url: URL(string: url)) { image in
                    image
                        .resizable()
                        .frame(height: 180)
                        .onTapGesture {
                            showImages.toggle()
                        }
                } placeholder: {
                    ProgressView()
                        .frame(width: UIScreen.main.bounds.width,
                               height: 180)
                }
            }
        }
        .frame(height: 180)
        .tabViewStyle(.page(indexDisplayMode: .never))
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
            if let openingHours = place.openingHours {
                HStack {
                    Text(DateHelper().getTodaysOpeningHours(for: openingHours))
                        .foregroundColor(.gray)
                        .bold()
                    Image(.infoCircle)
                        .foregroundColor(.gray)
                        .popover(isPresented: $showOpeningHours) {
                            OpeningHoursView(openingHours: openingHours)
                                .presentationCompactAdaptation(.popover)
                                .foregroundStyle(.gray)
                        }
                }
                .onTapGesture {
                    showOpeningHours.toggle()
                }
            }
            Spacer()
        }
    }

    private var buttonStack: some View {
        HStack {
            HStack {
                Image("googlemaps")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Nawiguj")
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
                        Image(.iphone)
                        Text("Zadzwoń")
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
    
    private var categories: some View {
        ScrollView(.horizontal) {
            HStack {
                PlaceCategoryCell(placeCategory: PlaceCategory(type: place.placeCategory))
                if let subCategories = place.subCategories, subCategories.isNotEmpty {
                    Divider()
                        .overlay(.black)
                        .frame(height: 35)
                    ForEach(subCategories, id: \.self) { category in
                        PlaceCategoryCell(placeCategory: PlaceCategory(type: category))
                    }
                }
            }
        }
        .frame(height: 50)
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(placeID: "")
            .environmentObject(PlaceService())
    }
}
