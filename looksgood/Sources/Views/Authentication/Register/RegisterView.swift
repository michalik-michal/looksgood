import SwiftUI

struct RegisterView: View {
    
    var accountType: AccountType
    
    @EnvironmentObject private var authService: AuthService
    @ObservedObject private var publisher = RegisterPublisher()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading) {
            LottieView(type: .confirmingOrder)
                .frame(width: 350, height: 350)
            Text(publisher.convertUserType(accountType))
                .font(.title.bold())
            CustomTextField(imageName: "envelope", placeholderText: Strings.email, text: $publisher.email)
            CustomTextField(imageName: "person", placeholderText: Strings.username, text: $publisher.username)
            CustomTextField(imageName: "lock", placeholderText: Strings.password, isSecureField: true, text: $publisher.password)
            Spacer()
            PlainButton(title: Strings.createAccount) {
                Task { try await authService.register(email: publisher.email,
                                                      password: publisher.password,
                                                      username: publisher.username,
                                                      accountType: accountType) }
                authService.didRegisterUSer = true
            }
            .fontWeight(.heavy)
        }
        .onTapGesture {
            endTextEditing()
        }
        .padding(.horizontal)
        .backNavigationButton()
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(accountType: .user)
    }
}
