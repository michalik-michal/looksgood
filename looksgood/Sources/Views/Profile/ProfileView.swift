import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject private var authService: AuthService
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        if let user = authService.currentUser {
            if authService.userSession != nil {
                VStack(alignment: .leading) {
                    Text(Strings.profile)
                        .font(.largeTitle.bold())
                        .padding(.horizontal)
                        .foregroundColor(.blackWhite)
                    Divider()
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text(Strings.username)
                                .bold()
                            PlainLabel(title: user.username, alignment: .leading)
                            Text(Strings.email)
                                .bold()
                            PlainLabel(title: user.email, alignment: .leading)
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        NavigationLink {
                            AccountSettingsView()
                        } label: {
                            SettingsCell(image: "gearshape", title: Strings.accountSettings)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        } else {
            LoginView()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
