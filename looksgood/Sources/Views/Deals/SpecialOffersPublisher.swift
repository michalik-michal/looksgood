import Foundation
import Firebase
import FirebaseStorage

class SpecialOffersPublisher: ObservableObject {
    
    @Published var specialOffers: [MenuItem] = []
    
    ///Fetch Special Offers
    func fetchSpecialOffers() async throws {
        let snapshot = try await Firestore.firestore()
            .collection("menuItems")
            .whereField("category", isEqualTo: "Special Offer")
            .getDocuments()
        let documents = snapshot.documents
        let menuItems = documents.compactMap({try? $0.data(as: MenuItem.self)})
        DispatchQueue.main.async {
            self.specialOffers = menuItems
        }
    }
}
