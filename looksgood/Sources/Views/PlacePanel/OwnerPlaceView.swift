import SwiftUI
import PhotosUI

struct OwnerPlaceView: View {
    
    @EnvironmentObject private var placeService: PlaceService
    @Namespace var animation
    @State private var showCategorySheet = false
    @State private var tabViewHeight = 0.0
    @State private var showSelectedImage = false
    @State private var showOpeningHours =  false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if let place = placeService.usersPlace {
                        if let imageURL = placeService.usersPlace?.imageURL, imageURL.isNotEmptyString {
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image
                                    .resizable()
                                    .frame(height: 180)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: UIScreen.main.bounds.width,
                                           height: 180)
                            }
                        } else {
                            addImage()
                        }
                        VStack {
                            VStack {
                                titleStack
                                adressStack
                                secondaryStack
                                VStack(spacing: 10) {
                                    PlainLabel(title: place.phoneNumber ?? "Add phone number",
                                               alignment: .leading,
                                               image: Image(.phone))
                                    PlainLabel(title: place.website ?? "Add website",
                                               alignment: .leading,
                                               image: Image(.globe))
                                    NavigationLink {
                                        OwnerMenuView()
                                            .backNavigationButton()
                                    } label: {
                                        PlainLabel(title: "Menu",
                                                   alignment: .leading,
                                                   image: Image(.book))
                                    }
                                    
                                }
                            }
                            .padding(.horizontal)
                            Spacer()
                        }
                    }
                }
            }
        }
        .onChange(of: placeService.imageState) { newValue in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showSelectedImage = true
            }
        }
        .sheet(isPresented: $showSelectedImage) {
            uploadPhotoSheet
        }
    }

    private func addImage() -> some View {
        AsyncImage(url: URL(string: placeService.usersPlace?.address ?? "")) { image in
            image
                .resizable()
                .frame(height: 180)
        } placeholder: {
            PhotosPicker(selection: $placeService.selectedPlaceImage,
                         matching: .any(of: [.images,
                                             .screenshots,
                                             .not(.videos)])) {
                                                 if placeService.selectedPlaceImage == nil {
                                                     VStack {
                                                         Image(.plus)
                                                             .resizable()
                                                             .frame(width: 25, height: 25)
                                                         Text(Strings.addImages)
                                                     }
                                                     .foregroundColor(.blackWhite)
                                                     .frame(maxWidth: .infinity)
                                                     .frame(height: 180)
                                                     .background(Color(.systemGray6))
                                                 } else {
                                                     Text("Photo added")
                                                         .foregroundColor(.blackWhite)
                                                         .frame(maxWidth: .infinity)
                                                         .frame(height: 180)
                                                         .background(Color(.systemGray6))
                                                         .cornerRadius(12)
                                                 }
                                             }
        }

    }

    private var uploadPhotoSheet: some View {
        VStack {
            HStack {
                Spacer()
                Text("Upload")
                    .onTapGesture {
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
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(12)
            default:
                Text("Unable to preview photo")
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
     
     private var titleStack: some View {
         HStack {
             Text(placeService.usersPlace?.name ?? "")
                 .font(.title.bold())
             Spacer()
             if let rating = placeService.usersPlace?.rating {
                 HStack {
                     Image(.starFill)
                         .resizable()
                         .foregroundColor(.yellow)
                         .frame(width: 15, height: 15)
                     Text(rating)
                         .foregroundColor(.gray)
                         .bold()
                     Text("(149)")
                         .foregroundColor(.gray)
                     Image("google")
                         .resizable()
                         .frame(width: 30, height: 30)
                 }
                 .padding(.top, 3)
                 .onTapGesture {
                     let link = "https://goo.gl/maps/bJMtrxCDRBzPYjPH7"
                     UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                 }
             }
             
         }
     }
     
     private var adressStack: some View {
         HStack {
             Text(placeService.usersPlace?.address ?? "Add address")
                 .foregroundColor(.gray)
             Spacer()
         }
     }
     
    private var secondaryStack: some View {
        HStack {
            PlaceCategoryCell(placeCategory: PlaceCategory(type: placeService.usersPlace?.placeCategory ?? .restaurant))
            Spacer()
            if let openingHours = placeService.usersPlace?.openingHours {
                HStack {
                    Text("10:00 - 23:00")
                        .foregroundColor(.gray)
                        .bold()
                    Image(.infoCircle)
                        .foregroundColor(.gray)
                        .popover(isPresented: $showOpeningHours) {
                            OpeningHoursView(openingHours: openingHours)
                                .presentationCompactAdaptation(.popover)
                                .foregroundStyle(.gray)
                        }
                }
                .onTapGesture {
                    showOpeningHours.toggle()
                }
            }
        }
        .padding(.bottom)
    }
 }


struct OwnerPlaceView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        OwnerPlaceView()
            .environmentObject( { () -> PlaceService in
                let object = PlaceService()
                object.usersPlace = Place(name: "Portobello",
                                          address: "Ul. Pod Wawelem 3b",
                                          rating: "4.2",
                                          phoneNumber: "123 456 789",
                                          website: "www.apple.com",
                                          placeCategory: .restaurant)
                return object
            }())
    }
}
