import SwiftUI
import GoogleMaps

struct CustomMarker: Equatable {
    var lat: Double
    var long: Double
    var title: String
    var id: String
}

struct GoogleMapsView: UIViewRepresentable {

    @EnvironmentObject fileprivate var locationManager: LocationManager
    @EnvironmentObject fileprivate var placeService: PlaceService
    @Binding var tappedMarker: CustomMarker?
    //This will be published or binding
    private let markers: [GMSMarker] = []
    
    private let zoom: Float = 15.0
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    
    func makeUIView(context: Context) -> GMSMapView {
        //TODO: - Fetching
        _ = placeService.markers
        let camera = GMSCameraPosition.camera(withLatitude: locationManager.latitude,
                                              longitude: locationManager.longitude,
                                              zoom: zoom)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = context.coordinator
        mapView.mapStyle = try? GMSMapStyle(jsonString: loadCustomMapStyle())
        placeService.markers.forEach { marker in
            let mapMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: marker.lat,
                                                                       longitude: marker.long))
            mapMarker.userData = context.coordinator
            mapMarker.map = mapView
        }
        return mapView
    }

    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if locationManager.shouldUpdateLocation {
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: locationManager.latitude,
                                                               longitude: locationManager.longitude))
        }
    }
    
    private func loadCustomMapStyle() -> String {
           guard let url = Bundle.main.url(forResource: "MapStyle", withExtension: "json") else {
               return ""
           }
           do {
               let data = try Data(contentsOf: url)
               return String(data: data, encoding: .utf8) ?? ""
           } catch {
               print("Failed to load custom map style: \(error)")
               return ""
           }
       }
}

class Coordinator: NSObject, GMSMapViewDelegate {
    let parent: GoogleMapsView
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var placeService: PlaceService

    init(_ parent: GoogleMapsView) {
        self.parent = parent
    }

    internal func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        mapView.animate(toZoom: 15.0)
        let markers = parent.placeService.markers
        let tappedMarker = markers.filter { $0.long == marker.position.longitude && $0.lat == marker.position.latitude }
        parent.tappedMarker = tappedMarker.first
        return true
    }
}

struct GoogleMapsView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleMapsView(tappedMarker: .constant(CustomMarker(lat: 0, long: 0, title: "", id: "")))
    }
}
