import SwiftUI
import PhotosUI

struct ImageGridView: View {

    var isOwnerView: Bool
    var placeID: String
    @State private var showAddPlaceImage = false
    @State private var showSelectedImage = false
    @State private var images: [String] = []
    @EnvironmentObject private var placeService: PlaceService

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(images, id: \.self) { url in
                    imageView(imageURL: url)
                }
            }
        }
        .onAppear {
            Task {
                images = try await placeService.fetchImages(with: placeID)
            }
        }
        .onChange(of: placeService.imageState) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if placeService.selectedPlaceImage != nil {
                    showSelectedImage = true
                }
            }
        }
        .sheet(isPresented: $showSelectedImage) {
            uploadPhotoSheet
        }
        .toolbar {
            if isOwnerView {
                ToolbarItem(placement: .navigationBarTrailing) {
                    PhotosPicker(selection: $placeService.selectedPlaceImage,
                                 matching: .any(of: [.images,
                                                     .screenshots,
                                                     .not(.videos)])) {
                                                         Image(.plus)
                                                             .resizable()
                                                             .frame(width: 25, height: 25)
                                                     }
                }
            }
        }
    }

    private func imageView(imageURL: String) ->  some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            NavigationLink {
                ImageDetailsView(image: image,
                                 url: imageURL,
                                 isOwnerView: isOwnerView)
                .backNavigationButton()
            } label: {
                image
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width)
                    .aspectRatio(16/9, contentMode: .fill)
            }
        } placeholder: {
            ProgressView()
                .frame(width: UIScreen.main.bounds.width,
                       height: 180)
        }
    }

    private var uploadPhotoSheet: some View {
        VStack {
            HStack {
                Button(Strings.cancel) {
                    showSelectedImage = false
                    placeService.selectedPlaceImage = nil
                }
                Spacer()
                Button(Strings.upload) {
                    Task {
                        if let placeDocumentID = placeService.usersPlace?.documentID {
                            try await placeService.uploadPlacePhoto(placeDocumentID)
                            showSelectedImage = false
                        }
                    }
                }
            }
            Spacer()
            switch placeService.imageState {
            case .success(let image):
                image
                    .resizable()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(12)
            default:
                Text(Strings.unableToPreviewPhoto)
            }
            Spacer()
        }
        .presentationDetents([.height(300)])
        .foregroundColor(.blackWhite)
        .padding()
        .onDisappear {
            placeService.selectedPlaceImage = nil
        }
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(isOwnerView: true, placeID: "")
    }
}
