import Firebase
import FirebaseStorage

class PlaceService: ObservableObject {
    
    @Published var usersPlace: Place?
    
    func uploadPlace(place: Place) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = ["uid": uid,
                    "name": place.name,
                    "address": place.address ?? "",
                    "googleMapsURL": place.googleMapsURL ?? "",
                    "googleMapsID": place.googleMapsID ?? "",
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
    
    func fetchUserPlace() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("places")
            .whereField("uid", isEqualTo: uid)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let places = documents.compactMap({try? $0.data(as: Place.self)})
                self.usersPlace = places.last
            }
    }
}


