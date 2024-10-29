import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject private var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var showRegisterView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading) {
            LottieView(type: .bunchOfFood)
                .frame(width: 350, height: 350)
            Text(Strings.login)
                .font(.title.bold())
                .foregroundColor(.blackWhite)
            CustomTextField(imageName: "envelope", placeholderText: Strings.email, text: $email)
            CustomTextField(imageName: "lock", placeholderText: Strings.password, isSecureField: true, text: $password)
            forgotPassword
            Spacer()
            PlainButton(title: Strings.letsGo) {
                Task { try await authService.logIn(email: email, password: password) }
                if authService.currentUser != nil && authService.userSession != nil {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .fontWeight(.heavy)
        }
        .padding(.horizontal)
        .onChange(of: authService.didRegisterUSer) { didRegisterUSer in
            if didRegisterUSer {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private var forgotPassword: some View {
        VStack {
            HStack {
                NavigationLink {
                    RegisterView(accountType: .user)
                } label: {
                    Text(Strings.createAccount)
                        .font(.callout.bold())
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
