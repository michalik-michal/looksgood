import SwiftUI

struct AccountSettingsView: View {
    
    @EnvironmentObject private var authService: AuthService
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var showLogoutConfirmation = false
    @State private var showDeleteAccountConfirmation = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Strings.accountSettings)
                .font(.largeTitle.bold())
                .padding(.horizontal)
                .foregroundColor(.blackWhite)
            Divider()
            ScrollView {
                VStack {
                    logOut
                    deleteAccount
                }
            }
        }
        .backNavigationButton()
    }
    
    private var logOut: some View {
        SettingsCell(image: "door.left.hand.open", title: Strings.logOut)
            .onTapGesture { showLogoutConfirmation.toggle() }
            .alert(isPresented: $showLogoutConfirmation) {
                Alert(
                    title: Text(Strings.logOut),
                    message: Text(Strings.areYouSure),
                    primaryButton: .destructive(Text(Strings.logOut)) {
                        authService.logOut()
                        authService.didLogOutUser = true
                    },
                    secondaryButton: .cancel())
            }
    }
    
    private var deleteAccount: some View {
        SettingsCell(image: "trash", title: Strings.deleteAccount)
            .onTapGesture { showDeleteAccountConfirmation.toggle() }
            .alert(isPresented: $showDeleteAccountConfirmation) {
                Alert(
                    title: Text(Strings.deleteAccount + "?"),
                    message: Text(Strings.deleteAccountConfirmation),
                    primaryButton: .destructive(Text(Strings.deleteAccount)) {
                        if let user = authService.currentUser {
                            Task { await authService.deleteAccount(uid: user.id) }
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    secondaryButton: .cancel())
            }
    }
}

struct AccountSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettingsView()
    }
}
