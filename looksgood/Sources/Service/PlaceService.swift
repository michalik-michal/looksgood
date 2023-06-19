import Firebase
import PhotosUI
import SwiftUI
import FirebaseStorage

class PlaceService: ObservableObject {
    
    @Published var usersPlace: Place?
    @Published var selectedItem: PhotosPickerItem? {
        didSet { }
    }
    
//MARK: - Place

    func uploadPlace(place: Place) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = ["uid": uid,
                    "id": UUID().uuidString,
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

//MARK: - Menu
    func uploadMenuItem(menuItem: MenuItem) async throws {
        guard let placeID = usersPlace?.id else { return }
        let data = [
            "placeID": placeID,
            "title": menuItem.title,
            "price": menuItem.price,
            "description": menuItem.description ?? "",
            "imageURL": menuItem.image ?? ""] as [String : Any]
        do {
            try await Firestore.firestore().collection("menuItems").document()
                .setData(data)
        } catch {
            print("Failed to upload menu item with error \(error.localizedDescription)")
        }
    }

    func uploadPhoto() async throws -> String? {
        guard let item = selectedItem else { return nil }
        guard let photoData = try await item.loadTransferable(type: Data.self) else { return nil }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("/menuPhotos/\(filename)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            let _ = try await ref.putDataAsync(photoData, metadata: metadata)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload photo with error \(error.localizedDescription)")
            return nil
        }
    }
}


