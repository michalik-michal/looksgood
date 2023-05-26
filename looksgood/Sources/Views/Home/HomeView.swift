import MapKit
import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            MapView()
                .zIndex(-10)
                .ignoresSafeArea()
            VStack {
                MapSearchField(text: $searchText)
                Spacer()
            }
            .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
