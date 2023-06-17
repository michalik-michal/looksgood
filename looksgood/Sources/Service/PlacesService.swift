import GooglePlaces

class PlacesService: NSObject, ObservableObject {
    
    @Published var searchResults: [GMSAutocompletePrediction] = []
    @Published var fetchedPlace = Place(name: "", placeCategory: .restaurant)
    let placesClient = GMSPlacesClient.shared()

    func searchPlace(query: String) {
        let autocompleteFilter = GMSAutocompleteFilter()
        autocompleteFilter.types = ["restaurant", "cafe", "bar", "meal_takeaway", "meal_delivery"]

        let token = GMSAutocompleteSessionToken.init()
        placesClient.findAutocompletePredictions(fromQuery: query, filter: autocompleteFilter, sessionToken: token, callback: { (results, error) in
            if let error = error {
                print("Autocomplete error: \(error.localizedDescription)")
                return
            }
            // If there are predictions, retrieve the place ID
            if let results = results {
                self.searchResults = results
            }
        })
    }
    
    func fetchPlaceDetails(_ id: String) {
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt64(UInt(GMSPlaceField.coordinate.rawValue) |
                                                                   UInt(GMSPlaceField.formattedAddress.rawValue) |
                                                                   UInt(GMSPlaceField.rating.rawValue) |
                                                                   UInt(GMSPlaceField.phoneNumber.rawValue) |
                                                                   UInt(GMSPlaceField.openingHours.rawValue) |
                                                                   UInt(GMSPlaceField.website.rawValue)))
        placesClient.fetchPlace(fromPlaceID: id, placeFields: fields, sessionToken: nil) { (place, error) in
            if let error = error {
                print("Place details error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                self.fetchedPlace.lat = place.coordinate.latitude.description
                self.fetchedPlace.long = place.coordinate.longitude.description
                self.fetchedPlace.phoneNumber = place.phoneNumber ?? ""
                self.fetchedPlace.rating = place.rating.description
                self.fetchedPlace.address = place.formattedAddress ?? ""
                self.fetchedPlace.website = place.website?.absoluteString ?? ""
                self.fetchedPlace.openingHours = place.openingHours?.weekdayText
            }
        }
    }
}
