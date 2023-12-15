import SwiftUI

struct PlaceListView: View {
    
    @EnvironmentObject private var placeSercive: PlaceService
    @State private var searchText = ""
    
    var body: some View {
        if placeSercive.places.isNotEmpty {
            VStack {
                ScrollView {
                    VStack(spacing: 0) {
                        searchField
                            .padding(.bottom, 7)
                        ForEach(searchablePlaces, id: \.self) { place in
                            PlaceCellView(place: place)
                            Divider()
                        }
                    }
                }
            }
            .onAppear {
                Task { try await placeSercive.fetchPlaces() }
            }
        } else {
            ProgressView()
                .onAppear {
                    Task {
                        try await placeSercive.fetchPlaces()
                    }
                }
        }
    }
    
    private var searchField: some View {
        HStack {
            Image(.magnifyingGlass)
                .foregroundColor(.gray)
                .padding(.leading)
            TextField("Search...", text: $searchText)
                .padding(.vertical)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.2), radius: 20, y: 5)
        .padding(5)
    }
    
    private var searchablePlaces: [Place] {
        if searchText.isEmpty {
            return placeSercive.places
        } else {
            let lowercasedQuery = searchText.lowercased()
            return placeSercive.places.filter({
                $0.name.lowercased().contains(lowercasedQuery)
            })
        }
    }
}

struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListView()
    }
}
