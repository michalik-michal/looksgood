import Firebase
import PhotosUI
import SwiftUI
import FirebaseStorage

class PlaceService: ObservableObject {
    
    @Published var usersPlace: Place?
    @Published var menuItems: [MenuItem]?
    @Published var placeMenuCategories: [FoodCategory]?
    @Published var imageState: ImageState = .empty
    @Published var markers: [CustomMarker] = []
    @Published var places: [Place] = []
    @Published var kid1: Kid?
    @Published var kid2: Kid?

    @Published var selectedMenuImage: PhotosPickerItem? {
        didSet {
            if let selectedMenuImage {
                _ = loadTransferable(from: selectedMenuImage)
                imageState = .loading
            } else {
                imageState = .empty
            }
        }
    }
    @Published var selectedPlaceImage: PhotosPickerItem? {
        didSet {
            if let selectedPlaceImage {
                _ = loadTransferable(from: selectedPlaceImage)
                imageState = .loading
            } else {
                imageState = .empty
            }
        }
    }
    
//MARK: - Place

    func uploadPlace(place: Place) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var data = ["uid": uid,
                    "id": UUID().uuidString,
                    "name": place.name,
                    "address": place.address ?? "",
                    "googleMapsURL": place.googleMapsURL ?? "",
                    "googleMapsID": place.googleMapsID ?? "",
                    "long": place.long ?? "",
                    "lat": place.lat ?? "",
                    "phoneNumber": place.phoneNumber ?? "",
                    "website": place.website ?? "",
                    "imageURLs": [""],
                    "openingHours":  place.openingHours as Any,
                    "placeCategory": place.placeCategory.rawValue,
                    "subCategories": [""]] as [String : Any]
        do {
            if data["long"] as! String == "" || data["lat"] as! String == "" {
                let coordinates = await LocationHelper().getCoordinates(from: data["address"] as! String)
                data["long"] = coordinates["long"]
                data["lat"] = coordinates["lat"]
            }
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

    func uploadPlacePhoto(_ placeDocumentID: String) async throws {
        let place = Firestore.firestore().collection("places").document(placeDocumentID)
        guard let item = selectedPlaceImage else { return }
        guard let photoData = try await item.loadTransferable(type: Data.self) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference().child("/placePhotos/\(filename)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            let _ = try await ref.putDataAsync(photoData, metadata: metadata)
            let url = try await ref.downloadURL()
            try await place.updateData(["imageURLs":  FieldValue.arrayUnion([url.absoluteString])])
        } catch {
            print("DEBUG: Failed to upload photo with error \(error.localizedDescription)")
            return
        }
    }

    /// Fetch place by placeID
    func fetchPlace(with id: String) async throws -> Place? {
        // Load the places.json file from the app bundle
        guard let fileURL = Bundle.main.url(forResource: "places", withExtension: "json") else {
            print("places.json file not found.")
            return nil
        }

        // Load the data from the file
        let jsonData = try Data(contentsOf: fileURL)

        // Decode the JSON data into an array of Place objects
        let decoder = JSONDecoder()
        let fetchedPlaces = try decoder.decode([Place].self, from: jsonData)

        // Find and return the place with the matching id
        let place = fetchedPlaces.first(where: { $0.id == id })
        
        return place
    }
    
//    func uploadSubCategory(_ category: PlaceCategoriesEnum) async throws {
//        if let placeDocumentID = usersPlace?.documentID {
//            let place = Firestore.firestore().collection("places").document(placeDocumentID)
//            try await place.updateData(["subCategories":  FieldValue.arrayUnion([category.rawValue])])
//        }
//    }
//    
//    /// Delete sub category
//    func deleteSubSategory(_ category: PlaceCategoriesEnum) async throws {
//        if let placeDocumentID = usersPlace?.documentID {
//            let place = Firestore.firestore().collection("places").document(placeDocumentID)
//            try await place.updateData(["subCategories":  FieldValue.arrayRemove([category.rawValue])])
//        }
//    }
//    /// Update place phone number
//    func updatePhoneNumber(_ phoneNumber: String) async throws {
//        if let placeDocumentID = usersPlace?.documentID {
//            let place = Firestore.firestore().collection("places").document(placeDocumentID)
//            try await place.updateData(["phoneNumber": phoneNumber])
//        }
//    }
//    
//    /// Update place website link
//    func updateWebsiteLink(_ websiteLink: String) async throws {
//        if let placeDocumentID = usersPlace?.documentID {
//            let place = Firestore.firestore().collection("places").document(placeDocumentID)
//            try await place.updateData(["website": websiteLink])
//        }
//    }

//MARK: - Menu

    func uploadMenuItem(menuItem: MenuItem) async throws {
        guard let placeID = usersPlace?.id else { return }
        let data = [
            "placeID": placeID,
            "title": menuItem.title,
            "price": menuItem.price,
            "category": menuItem.category.rawValue,
            "description": menuItem.description ?? "",
            "imageURL": menuItem.imageURL ?? ""] as [String : Any]
        do {
            try await Firestore.firestore().collection("menuItems").document()
                .setData(data)
        } catch {
            print("Failed to upload menu item with error \(error.localizedDescription)")
        }
    }

    func uploadmenuItemPhoto() async throws -> String? {
        guard let item = selectedMenuImage else { return nil }
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

    func fetchMenuItems() async throws {
        guard let placeID = usersPlace?.id else { return }
        Firestore.firestore().collection("menuItems")
            .whereField("placeID", isEqualTo: placeID)
            .addSnapshotListener { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let menuItems = documents.compactMap({try? $0.data(as: MenuItem.self)})
                self.menuItems = menuItems
                self.retreiveCategories(from: menuItems)
            }
    }

    ///Fetch menu items with placeID
    func fetchMenuItems(with placeID: String) async throws -> [MenuItem]? {
       let snapshot = try await Firestore.firestore()
            .collection("menuItems")
            .whereField("placeID", isEqualTo: placeID)
            .getDocuments()
        let documents = snapshot.documents
        let menuItems = documents.compactMap({try? $0.data(as: MenuItem.self)})
        return menuItems
    }

    private func retreiveCategories(from menuItems: [MenuItem]) {
        var categories: [FoodCategory] = []
        for menuItem in menuItems {
            if categories.contains(menuItem.category) {
                continue
            }
            categories.append(menuItem.category)
        }
        placeMenuCategories = categories.sorted()
        if !(placeMenuCategories?.contains(.All) ?? true) {
            placeMenuCategories?.insert(.All, at: 0)
        }
    }
    
    func retreiveCategories(for menuItems: [MenuItem]) -> [FoodCategory] {
        var categories: [FoodCategory] = []
        for menuItem in menuItems {
            if categories.contains(menuItem.category) {
                continue
            }
            categories.append(menuItem.category)
        }
        if !(categories.contains(.All)) {
            categories.insert(.All, at: 0)
        }
        return categories.sorted()
    }

    func deleteMenuItem(_ item: MenuItem) async throws {
        if let id = item.id {
            try await deleteImage(for: item)
            try await Firestore.firestore().collection("menuItems").document(id).delete()
        }
    }
    
    ///Delete menu image from storage
    private func deleteImage(for item: MenuItem) async throws {
        if let url = item.imageURL {
            if url.isNotEmptyString {
                try await Storage.storage().reference().storage.reference(forURL: url).delete()
            }
        }
    }
    
    //MARK: - Image

    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Image.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage)
                case .success(nil):
                    self.imageState = .empty
                case .failure:
                    self.imageState = .failure
                }
            }
        }
    }
    
    func fetchImages(with placeID: String) async throws -> [String] {
        let snapshot = try await Firestore.firestore()
            .collection("places")
            .whereField("id", isEqualTo: placeID)
            .getDocuments()
        let documents = snapshot.documents
        let place = documents.compactMap({try? $0.data(as: Place.self)})
        return place.first?.imageURLs ?? []
    }
    
    ///Delete Image from database
    func deletePlaceImage(for placeDocumentID: String, url: String) async throws {
        // Delete image from storage
        try await Storage.storage().reference().storage.reference(forURL: url).delete()
        
        let place = Firestore.firestore().collection("places").document(placeDocumentID)
        try await place.updateData(["imageURLs":  FieldValue.arrayRemove([url])])
    }

    //MARK: - Markers
    
    func fetchMarkers() async throws {
        var fetchedMarkers: [CustomMarker] = []

        guard let fileURL = Bundle.main.url(forResource: "places", withExtension: "json") else {
            print("places.json file not found.")
            return
        }
        
        let jsonData = try Data(contentsOf: fileURL)

        let decoder = JSONDecoder()
        let fetchedPlaces = try decoder.decode([Place].self, from: jsonData)

        for place in fetchedPlaces {
            let marker = CustomMarker(lat: Double(place.lat ?? "") ?? 0.0,
                                      long: Double(place.long ?? "") ?? 0.0,
                                      title: place.name,
                                      id: place.id?.isEmpty == false ? place.id! : UUID().uuidString) // Generate ID if missing
            fetchedMarkers.append(marker)
        }

        DispatchQueue.main.sync {
            self.markers = fetchedMarkers
        }
    }
    
    //MARK: - Places
    
    //TODO: - It should be also done by nearest location
    func fetchPlaces() async throws {
        guard let fileURL = Bundle.main.url(forResource: "places", withExtension: "json") else {
            print("places.json file not found.")
            return
        }
        
        let jsonData = try Data(contentsOf: fileURL)

        let decoder = JSONDecoder()
        let fetchedPlaces = try decoder.decode([Place].self, from: jsonData)
        DispatchQueue.main.async {
            self.places = fetchedPlaces
        }
    }

    func fetchKid1() async throws {
        guard let fileURL = Bundle.main.url(forResource: "kid1", withExtension: "json") else {
            print("places.json file not found.")
            return
        }
        
        let jsonData = try Data(contentsOf: fileURL)

        let decoder = JSONDecoder()
        let kid1 = try decoder.decode(Kid.self, from: jsonData)
        DispatchQueue.main.async {
            self.kid1 = kid1
        }
    }
}
