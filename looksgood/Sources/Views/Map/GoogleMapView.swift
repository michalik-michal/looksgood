import SwiftUI
import GoogleMaps

struct CustomMarker {
    var lat: Double
    var long: Double
    var title: String
}

struct GoogleMapsView: UIViewRepresentable {

    @EnvironmentObject fileprivate var locationManager: LocationManager
    //This will be published or binding
    private let markers: [GMSMarker] = []
    
    
    private let zoom: Float = 15.0
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude, longitude: locationManager.longitude, zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = context.coordinator
        locationManager.customMarkers.forEach { marker in
            let mapMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: marker.lat, longitude: marker.long))
            mapMarker.userData = context.coordinator
            mapMarker.map = mapView
        }
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude))
    }
}

class Coordinator: NSObject, GMSMapViewDelegate {
    let parent: GoogleMapsView

    @EnvironmentObject private var locationManager: LocationManager

    init(_ parent: GoogleMapsView) {
        self.parent = parent
    }

    internal func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        mapView.animate(toZoom: 15.0)
        let markers = parent.locationManager.customMarkers
        let tappedMarker = markers.filter { $0.long == marker.position.longitude && $0.lat == marker.position.latitude }

        return true
    }
}

struct GoogleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapsView()
    }
}
