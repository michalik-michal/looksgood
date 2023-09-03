import SwiftUI

struct PlaceListView: View {
    
    @EnvironmentObject private var placeSercive: PlaceService
    
    var body: some View {
        if !placeSercive.places.isEmpty {
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(placeSercive.places, id: \.self) { place in
                        PlaceCellView(place: place)
                        Divider()
                    }
                }
            }
            .onAppear {
                Task { try await placeSercive.fetchPlaces() }
            }
        } else {
            ProgressView()
                .onAppear {
                    Task { try await placeSercive.fetchPlaces() }
                }
        }
    }
}

struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListView()
    }
}
