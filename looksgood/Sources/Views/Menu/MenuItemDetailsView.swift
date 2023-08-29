import SwiftUI
import PhotosUI

struct MenuItemDetailsView: View {
    
    var menuItem: MenuItem
    var ownerView: Bool
    @State private var showDeleteItemAlert = false
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var placeService: PlaceService
    
    init(menuItem: MenuItem, ownerView: Bool = true) {
        self.menuItem = menuItem
        self.ownerView = ownerView
    }
    
    var body: some View {
        VStack {
            if let imageURL = menuItem.imageURL {
                if imageURL != "" {
                    AsyncImage(url: URL(string: imageURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                            .frame(height: 180)
                    }
                } else {
                    photoPicker
                }
            } else {
                photoPicker
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(menuItem.title)
                        .font(.title.bold())
                    Spacer()
                    Text(menuItem.price)
                        .font(.title.bold())
                }
                Text(menuItem.description ?? "")
                    .padding(.top, 5)
            }
            .padding(.horizontal)
            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(.trash)
                    .foregroundColor(.blackWhite)
                    .onTapGesture { showDeleteItemAlert.toggle() }
                    .hide(if: !ownerView)
            }
        }
        .alert(isPresented: $showDeleteItemAlert) {
            Alert(
                title: Text("Delete item?"),
                message: Text("This menu item will be deleted forever."),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        try await placeService.deleteMenuItem(menuItem)
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                secondaryButton: .cancel())
        }
    }

    private var photoPicker: some View {
        PhotosPicker(selection: $placeService.selectedMenuImage,
                     matching: .any(of: [.images,
                                         .screenshots,
                                         .not(.videos)])) {
                                             if placeService.selectedMenuImage == nil {
                                                 VStack {
                                                     Image(.plus)
                                                         .resizable()
                                                         .frame(width: 25, height: 25)
                                                     Text("Add image for this item.")
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

struct MenuItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemDetailsView(menuItem: MenuItem(placeID: "",
                                               title: "Burger",
                                               price: "35 USD",
                                               category: .Burger,
                                               description: "This is an amazing burger"))
        .environmentObject( { () -> PlaceService in
            let object = PlaceService()
            return object
        }())
    }
}
