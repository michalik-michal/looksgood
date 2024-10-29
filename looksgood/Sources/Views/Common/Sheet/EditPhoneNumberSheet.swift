import SwiftUI

struct EditPhoneNumberSheet: View {
    
    var oldPhoneNumber: String
    @State private var phoneNumber = ""
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
                     //       try await placeService.updatePhoneNumber(phoneNumber)
                            showSheet = false
                        }
                    }
            }
            .padding()
            CustomTextField(imageName: "phone",
                            placeholderText: Strings.phoneNumber,
                            text: $phoneNumber)
            .padding(.horizontal)
        }
        .presentationDetents([.height(100)])
        .onAppear {
            phoneNumber = oldPhoneNumber
        }
    }
}

struct EditPhoneNumberSheet_Previews: PreviewProvider {
    static var previews: some View {
        EditPhoneNumberSheet(oldPhoneNumber: "123 456 789", showSheet: .constant(false))
    }
}
