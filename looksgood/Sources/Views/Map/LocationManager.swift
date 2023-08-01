import Combine
import CoreLocation

@MainActor
class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var shouldUpdateLocation = true
    @Published var location: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var pickedMarker: CustomMarker?
    @Published var customMarkers: [CustomMarker] = []
    @Published var shouldReloadMap = false
    
    var latitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 50.059683
    }
    
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 19.934544
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Show some alert")
        case .denied:
            print("Show some alert")
        case .authorizedAlways, .authorizedWhenInUse:
            if let center = locationManager.location?.coordinate {
                location = CLLocation(latitude: center.latitude, longitude: center.longitude)
            }
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if shouldUpdateLocation {
            guard let location = locations.last else { return }
            self.location = location
        }
    }
}
