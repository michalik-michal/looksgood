import SwiftUI

struct AddPlaceView: View {
    
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
    @State private var showInfoSheet = false
    @State private var selectedCategory: PlaceCategoriesEnum?
    @EnvironmentObject private var placesService: PlacesService
    @ObservedObject private var addRestaurantPublisher = AddPlacePublisher()
    
    init(place: SearchedPlace = SearchedPlace(id: "", name: ""),
         showRatingField: Bool = true) {
        self.searchedPlace = place
        self.showRatingField = showRatingField
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
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
                HStack {
                    Text("Select category")
                        .font(.title2)
                        .bold()
                    Spacer()
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            showInfoSheet.toggle()
                        }
                }
                .padding(.horizontal)
                RestaurantCategoryPicker(selectedCategory: $selectedCategory)
                    .padding(.horizontal, 3)
            }
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

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaceView()
            .environmentObject(PlacesService())
    }
}
