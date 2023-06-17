import SwiftUI

struct PlacePanelView: View {

    @EnvironmentObject private var authService: AuthService
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var placeService: PlaceService

    var body: some View {
        VStack {
            if let _ = placeService.usersPlace {
                OwnerPlaceView()
            } else {
                NoUserPlacesView()
            }
        }
        .onAppear {
            placeService.fetchUserPlace()
        }
        .onChange(of: appState.didUploadPlace) { didUpload in
            if didUpload {
                //
            }
        }
    }
}

struct PlacePanelView_Previews: PreviewProvider {
    static var previews: some View {
        PlacePanelView()
    }
}
