import SwiftUI

struct SearchAddPlaceView: View {
    
    @State private var searchText = ""
    @State private var selectedPlace: SearchedPlace?
    @EnvironmentObject private var placesManager: PlacesService
    
    var body: some View {
        VStack {
            CustomTextField(imageName: "magnifyingglass", placeholderText: "Search on GoogleMaps...", text: $searchText)
            ScrollView {
                VStack {
                    ForEach(placesManager.searchResults, id: \.self) { place in
                        SearchPlaceCell(id: place.placeID,
                                             title: place.attributedPrimaryText.string,
                                             address: place.attributedSecondaryText?.string ?? "")
                        .onTapGesture {
                            let place = SearchedPlace(id: place.placeID,
                                                      name: place.attributedPrimaryText.string)
                            selectedPlace = place
                            Impact().makeImpact(.medium)
                        }
                        .foregroundColor(place.placeID == selectedPlace?.id ? .orange : .blackWhite)
                        //.opacity((!(place.placeID == selectedPlace) && selectedPlace != "") ? 0.5 : 1)
                    }
                }
            }
            Spacer()
            NavigationLink {
                AddPlaceView(place: selectedPlace ?? SearchedPlace(id: "", name: ""))
                    .backNavigationButton()
            } label: {
                PlainLabel(title: Strings.next)
            }
        }
        .padding(.horizontal)
        .onChange(of: searchText) { query in
            if query.count > 4 {
                placesManager.searchPlace(query: query)
            }
        }
    }
}

struct SearchAddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        SearchAddPlaceView()
    }
}
