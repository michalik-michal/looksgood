import SwiftUI

struct PlaceView: View {
    
    @EnvironmentObject private var placeService: PlaceService
    var placeID: String
    @State private var place = Place(name: "", placeCategory: .restaurant)

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
            }
        }
        .onAppear {
            Task {
                if let fetchedPlace = try await placeService.fetchPlace(with: placeID) {
                    place = fetchedPlace
                }
            }
        }
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(placeID: "")
    }
}
