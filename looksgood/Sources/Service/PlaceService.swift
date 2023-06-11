import Firebase
import FirebaseStorage

class PlaceService: ObservableObject {
    
    func uploadPlace(place: Place) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = ["uid": uid,
                    "name": place.name,
                    "address": place.address ?? "",
                    "googleMapsURL": place.googleMapsURL ?? "",
                    "long": place.long ?? "",
                    "lat": place.lat ?? "",
                    "phoneNumber": place.phoneNumber ?? "",
                    "website": place.website ?? "",
                    "placeCategory": place.placeCategory.rawValue] as [String : Any]
        do {
            try await Firestore.firestore().collection("places").document()
                .setData(data)
        } catch {
            print("Failed to upload place with error \(error.localizedDescription)")
        }
    }
}


