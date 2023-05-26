import SwiftUI
import MapKit

struct MapView: View {

    @ObservedObject private var publisher = MapPublisher()
    
    var body: some View {
        Map(coordinateRegion: $publisher.mapLocation, showsUserLocation: true)
            .onAppear {
                publisher.checkIfLocationIsEnabled()
            }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
