import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var showRegisterView = false
    
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
                // Log in
            }
            .fontWeight(.heavy)
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $showRegisterView) {
            RegisterView()
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
