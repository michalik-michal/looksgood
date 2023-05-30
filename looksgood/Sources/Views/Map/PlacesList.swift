import SwiftUI

struct PlacesList: View {

    @ObservedObject private var placesManager = PlacesManager()
    
    var body: some View {
        NavigationView {
            List(placesManager.places, id: \.place.placeID) { placeLikelihood in
                PlaceRow(place: placeLikelihood.place)
            }
            .navigationBarTitle("Nearby Locations")
        }
    }
}

struct PlacesList_Previews: PreviewProvider {
    static var previews: some View {
        PlacesList()
    }
}
