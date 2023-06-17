import Foundation

@MainActor
class AppState: ObservableObject {
    
    @Published var pickedMarker: CustomMarker?
    @Published var didUploadPlace = false
    
}
