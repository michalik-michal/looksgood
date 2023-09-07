import SwiftUI

struct ImageDetailsView: View {
    
    var image: Image
    var url: String
    var isOwnerView: Bool

    @State private var showConfirmation = false
    @EnvironmentObject private var placeService: PlaceService
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        image
            .resizable()
            .frame(width: UIScreen.main.bounds.width)
            .aspectRatio(16/9, contentMode: .fit)
            .toolbar {
                if isOwnerView {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showConfirmation.toggle()
                        } label: {
                            Image(.trash)
                                .resizable()
                                .frame(width: 22, height: 25)
                        }
                        .alert(isPresented: $showConfirmation) {
                            Alert(
                                title: Text("Are you sure?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    Task {
                                        if let placeDocumentID = placeService.usersPlace?.documentID {
                                            try await placeService.deletePlaceImage(for: placeDocumentID, url: url)
                                            presentationMode.wrappedValue.dismiss()
                                        }
                                    }
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
            }
    }
}
