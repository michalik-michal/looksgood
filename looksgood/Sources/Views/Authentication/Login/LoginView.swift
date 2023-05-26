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
            CustomTextField(imageName: "envelope", placeholderText: Strings.email, text: $email)
            CustomTextField(imageName: "lock", placeholderText: Strings.password, isSecureField: true, text: $password)
            forgotPassword
            Spacer()
            PlainButton(title: Strings.letsGo) {
                Task { try await authService.logIn(email: "", password: "") }
            }
            .fontWeight(.heavy)
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showRegisterView) {
            RegisterView()
        }
        .overlay(alignment: .topLeading) {
            closeButton
        }
    }

    private var forgotPassword: some View {
        VStack {
            HStack {
                Text(Strings.createAccount)
                    .font(.callout.bold())
                    .foregroundColor(.gray)
                    .onTapGesture {
                        showRegisterView.toggle()
                    }
                Spacer()
                Text(Strings.forgotPassword)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .onTapGesture {
                        // Handle Forgot Password
                    }
            }
        }
    }

    private var closeButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
