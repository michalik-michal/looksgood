import SwiftUI
import PhotosUI

struct OwnerPlaceView: View {
    
    @EnvironmentObject private var placeService: PlaceService
    @Namespace var animation
    @State private var showOpeningHours =  false
    @State private var selectedSubCategory: PlaceCategoriesEnum?
    @State private var selectedSheet: OwnerPlaceSheet?
    @State private var showSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if let place = placeService.usersPlace {
                        if let imageURL = placeService.usersPlace?.imageURLs?.first, imageURL.isNotEmptyString {
                            imageView(imageURL: imageURL)
                        } else {
                            addImage()
                        }
                        VStack {
                            VStack {
                                titleStack
                                adressStack
                                secondaryStack
                                categories
                                VStack(spacing: 10) {
                                    PlainLabel(title: place.phoneNumber ?? "Add phone number",
                                               alignment: .leading,
                                               image: Image(.phone))
                                    .onTapGesture {
                                        Task {
                                            DispatchQueue.main.async {
                                                selectedSheet = .editPhoneNumber
                                            }
                                            showSheet = true
                                        }
                                    }
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
                if placeService.selectedPlaceImage != nil {
                    selectedSheet = .selectedImage
                }
            }
            showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            if let sheet = selectedSheet {
                switch sheet {
                case .selectedImage:
                    uploadPhotoSheet
                case .addSubCategory:
                    AddSubCategorySheet(showSheet: $showSheet)
                        .presentationDetents([.height(200)])
                case .editPhoneNumber:
                    EditPhoneNumberSheet(oldPhoneNumber: placeService.usersPlace?.phoneNumber ?? "",
                                         showSheet: $showSheet)
                case .deleteSubCategory:
                    if let selectedSubCategory = selectedSubCategory {
                        DeleteSubCategorySheet(category: selectedSubCategory,
                                               showSheet: $showSheet)
                    } else {
                        //TODO: - First open
                        Text("Something went wrong")
                            .presentationDetents([.height(100)])
                    }
                }
            }
        }
    }
    
    private func imageView(imageURL: String) ->  some View {
        NavigationLink {
            ImageGridView(isOwnerView: true,
                          placeID: placeService.usersPlace?.id ?? "")
        } label: {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .frame(height: 180)
            } placeholder: {
                ProgressView()
                    .frame(width: UIScreen.main.bounds.width,
                           height: 180)
            }
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
                Button(Strings.cancel) {
                    showSheet = false
                    placeService.selectedPlaceImage = nil
                }
                Spacer()
                Button(Strings.upload) {
                    Task {
                        if let placeDocumentID = placeService.usersPlace?.documentID {
                            try await placeService.uploadPlacePhoto(placeDocumentID)
                            showSheet = false
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
            if let openingHours = placeService.usersPlace?.openingHours {
                HStack {
                    Text(DateHelper().getTodaysOpeningHours(for: openingHours))
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
            Spacer()
        }
    }
    
    private var categories: some View {
        ScrollView(.horizontal) {
            HStack {
                PlaceCategoryCell(placeCategory: PlaceCategory(type: placeService.usersPlace?.placeCategory ?? .restaurant))
                if let subCategories = placeService.usersPlace?.subCategories {
                    Divider()
                        .overlay(.black)
                    ForEach(subCategories, id: \.self) { category in
                        PlaceCategoryCell(placeCategory: PlaceCategory(type: category))
                            .onTapGesture {
                                Task {
                                    DispatchQueue.main.async {
                                        selectedSubCategory = category
                                        selectedSheet = .deleteSubCategory
                                    }
                                    showSheet = true
                                }
                            }
                    }
                }
                Image(.plusCircle)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        Task {
                            DispatchQueue.main.async {
                                selectedSheet = .addSubCategory
                            }
                            showSheet.toggle()
                        }
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
