import SwiftUI

struct EditWebsiteLinkSheet: View {
    
    var oldWebsiteLink: String
    @State private var websiteLink = ""
    @Binding var showSheet: Bool
    @EnvironmentObject private var placeService: PlaceService
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(Strings.update)
                    .bold()
                    .onTapGesture {
                        Task {
                      //      try await placeService.updateWebsiteLink(websiteLink)
                            showSheet = false
                        }
                    }
            }
            .padding()
            CustomTextField(imageName: "globe",
                            placeholderText: Strings.website,
                            text: $websiteLink)
            .padding(.horizontal)
        }
        .presentationDetents([.height(100)])
        .onAppear {
            websiteLink = oldWebsiteLink
        }
    }
}

struct EditWebsiteLinkSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditWebsiteLinkSheet(oldWebsiteLink: "www.apple.com",
                             showSheet: .constant(false))
    }
}
