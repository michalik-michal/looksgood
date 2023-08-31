import SwiftUI

class GoogleMapsService: ObservableObject {
    static var shared = GoogleMapsService()
    
    func navigateOnGoogleMap(sourceLatitude : Double, sourceLongitude : Double, destinationLatitude : Double, destinationLongitude : Double) {
        let urlGoogleMap : URL = URL(string: "comgooglemaps://?saddr=\(sourceLatitude),\(sourceLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving")!
        if UIApplication.shared.canOpenURL(urlGoogleMap) {
            UIApplication.shared.open(urlGoogleMap, options: [:], completionHandler: nil)
        } else {
            let urlString = URL(string:"http://maps.google.com/?saddr=\(sourceLatitude),\(sourceLongitude)&daddr=\(destinationLatitude),\(destinationLongitude)&directionsmode=driving")
            
            UIApplication.shared.open(urlString!, options: [:], completionHandler: nil)
        }
    }
}
