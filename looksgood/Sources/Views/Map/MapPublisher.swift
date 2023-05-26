import Foundation
import MapKit

class MapPublisher: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapLocation = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50.059683,
                                       longitude: 19.934544),
        latitudinalMeters: 2500,
        longitudinalMeters: 2500)
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            checkLocationAuthorization()
            locationManager?.delegate = self
        } else {
            print("Show alert to enable location")
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Show some alert")
        case .denied:
            print("Show some alert")
        case .authorizedAlways, .authorizedWhenInUse:
            if let center = locationManager.location?.coordinate {
                mapLocation = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
            }
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
