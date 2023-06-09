import SwiftUI

struct AddRestaurantView: View {
    
    @State private var id: String = ""
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var googleMapsURL: String = ""
    @State private var long: String = ""
    @State private var lat: String = ""
    @State private var rating: String = ""
    @State private var phoneNumber: String = ""
    @State private var website: String = ""
    @State private var showRatingField: Bool
    @State private var searchedPlace: SearchedPlace
    @EnvironmentObject private var placesService: PlacesService
    @ObservedObject private var addRestaurantPublisher = AddRestaurantPublisher()
    
    init(place: SearchedPlace = SearchedPlace(id: "", name: ""),
         showRatingField: Bool = true) {
        self.searchedPlace = place
        self.showRatingField = showRatingField
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                CustomTextField(imageName: "house", placeholderText: "Place name", text: $name)
                CustomTextField(imageName: "mappin", placeholderText: "Adcress", text: $address)
                CustomTextField(imageName: "map", placeholderText: "GoogleMaps Link (recommended)", text: $googleMapsURL)
                CustomTextField(imageName: "phone", placeholderText: "Phone number", text: $phoneNumber)
                    .keyboardType(.numberPad)
                CustomTextField(imageName: "globe", placeholderText: "Website", text: $website)
                if showRatingField {
                    CustomTextField(imageName: "star", placeholderText: "Stars", text: $rating)
                        .disabled(true)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            placesService.fetchPlaceDetails(searchedPlace.id)
            updatePlaceDetails()
        }
        .onDisappear {
            placesService.fetchedPlace = Place(name: "")
        }
        .onChange(of: placesService.fetchedPlace) { _ in
            updatePlaceDetails()
        }
        .overlay(alignment: .bottom) {
            PlainButton(title: Strings.done) {
                //
            }
            .padding()
        }
        .onTapGesture {
            endTextEditing()
        }
    }

    private func updatePlaceDetails() {
        let place = placesService.fetchedPlace
        id = place.id ?? ""
        name = searchedPlace.name
        address = place.address ?? ""
        googleMapsURL = place.googleMapsURL ?? ""
        long = place.long ?? ""
        lat = place.lat ?? ""
        rating = place.rating ?? ""
        phoneNumber = place.phoneNumber?.description ?? ""
        website = place.website?.description ?? ""
    }
}

struct AddRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        AddRestaurantView()
            .environmentObject(PlacesService())
    }
}
