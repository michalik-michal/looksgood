import SwiftUI

class RegisterPublisher: ObservableObject {

    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var selectedType = "Restaurant owner"
    @Published var screenState: ScreenState = .initial
    
    enum ScreenState {
        case initial
        case inProgress
    }
    
    func resetFields() {
        email = ""
        username = ""
        password = ""
        selectedType = ""
        screenState = .initial
    }
}
