import SwiftUI

struct AddPlaceView: View {

    @EnvironmentObject private var placesService: PlacesService
    @EnvironmentObject private var placeService: PlaceService
    @EnvironmentObject private var appState: AppState
    @ObservedObject private var addRestaurantPublisher = AddPlacePublisher()

    @State private var place = Place(name: "",
                                     placeCategory: .restaurant)
    @State private var rating: String = ""
    @State private var searchedPlace: SearchedPlace
    @State private var showRatingField: Bool
    @State private var showInfoSheet = false
    @State private var selectedCategory: PlaceCategoriesEnum?
    
    init(place: SearchedPlace = SearchedPlace(id: "", name: ""),
         showRatingField: Bool = true) {
        self.searchedPlace = place
        self.showRatingField = showRatingField
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                VStack(spacing: 15) {
                    CustomTextField(imageName: "house",
                                    placeholderText: "Place name",
                                    text: $place.name)
                    CustomTextField(imageName: "mappin",
                                    placeholderText: "Adcress",
                                    text: $place.address.safe(""))
                    CustomTextField(imageName: "map",
                                    placeholderText: "GoogleMaps Link (recommended)",
                                    text: $place.googleMapsURL.safe(""))
                    CustomTextField(imageName: "phone",
                                    placeholderText: "Phone number",
                                    text: $place.phoneNumber.safe(""))
                        .keyboardType(.numberPad)
                    CustomTextField(imageName: "globe",
                                    placeholderText: "Website",
                                    text: $place.website.safe(""))
                    if showRatingField {
                        CustomTextField(imageName: "star",
                                        placeholderText: "Stars",
                                        text: $rating)
                            .disabled(true)
                    }
                }
                .padding(.horizontal)
                HStack {
                    Text(Strings.selectCategory)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Image(.infoCircle)
                        .foregroundColor(.gray)
                        .onTapGesture {
                            showInfoSheet.toggle()
                        }
                }
                .padding(.horizontal)
                PlaceCategoryPicker(selectedCategory: $selectedCategory)
            }
        }
        .onAppear {
            if searchedPlace.id != "" {
                placesService.fetchPlaceDetails(searchedPlace.id)
            }
            updatePlaceDetails()
        }
        .onDisappear {
            placesService.fetchedPlace = Place(name: "", placeCategory: .restaurant)
        }
        .onChange(of: placesService.fetchedPlace) { _ in
            updatePlaceDetails()
        }
        .overlay(alignment: .bottom) {
            PlainButton(title: Strings.done) {
                uploadPlace()
            }
            .padding()
        }
        .onTapGesture {
            endTextEditing()
        }
        .sheet(isPresented: $showInfoSheet) {
            VStack {
                Text(Strings.categoryInfo)
                    .font(.title2).bold()
                Spacer()
            }
            .padding()
            .presentationDetents([.height(200)])
        }
    }

    private func updatePlaceDetails() {
        let fetchedPlace = placesService.fetchedPlace
        place.id = fetchedPlace.id ?? ""
        place.name = searchedPlace.name
        place.address = fetchedPlace.address ?? ""
        place.googleMapsURL = fetchedPlace.googleMapsURL ?? ""
        place.googleMapsID = searchedPlace.id
        place.long = fetchedPlace.long ?? ""
        place.lat = fetchedPlace.lat ?? ""
        place.rating = fetchedPlace.rating ?? ""
        place.phoneNumber = fetchedPlace.phoneNumber?.description ?? ""
        place.website = fetchedPlace.website?.description ?? ""
        place.openingHours = fetchedPlace.openingHours
    }
    
    private func uploadPlace() {
        place.placeCategory = selectedCategory ?? .restaurant
        Task { try await placeService.uploadPlace(place: place) }
        appState.didUploadPlace = true
    }
}

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
            .environmentObject(PlacesService())
    }
}
