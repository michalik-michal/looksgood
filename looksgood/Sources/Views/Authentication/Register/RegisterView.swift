import SwiftUI

struct RegisterView: View {
    
    @ObservedObject private var publisher = RegisterPublisher()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .leading) {
            switch publisher.screenState {
            case .initial:
                initialScreen
                    .transition(.opacity)
            case .inProgress:
                inProgressScreen
                    .transition(.opacity)
            }
        }
        .onTapGesture {
            endTextEditing()
        }
        .padding(.horizontal)
        .overlay(alignment: .topLeading) {
            if publisher.screenState == .inProgress {
                backButton
            } else {
                closeButton
            }
        }
    }
    
    private var initialScreen: some View {
        VStack() {
            LottieView(type: .phone)
                .frame(width: 350, height: 350)
            HStack {
                Text(Strings.whoAreYou)
                    .font(.title.bold())
                Spacer()
            }
            PlainButton(title: Strings.restaurantOwner) {
                publisher.selectedType = Strings.restaurantOwner
            }
            .fontWeight(publisher.selectedType == Strings.restaurantOwner ? .heavy : .regular)
            Text("or")
                .font(.title3.bold())
            PlainButton(title: Strings.user) {
                publisher.selectedType = Strings.user
            }
            .fontWeight(publisher.selectedType == Strings.user ? .heavy : .regular)
            Spacer()
            PlainButton(title: Strings.go) {
                if publisher.selectedType != "" {
                    publisher.screenState = .inProgress
                }
            }
            .fontWeight(.heavy)
        }
        
    }
    
    private var inProgressScreen: some View {
        VStack(alignment: .leading) {
            LottieView(type: .phone)
                .frame(width: 350, height: 350)
            Text(publisher.selectedType)
                .font(.title.bold())
            CustomTextField(imageName: "envelope", placeholderText: Strings.email, text: $publisher.email)
            CustomTextField(imageName: "person", placeholderText: Strings.username, text: $publisher.username)
            CustomTextField(imageName: "lock", placeholderText: Strings.password, isSecureField: true, text: $publisher.password)
            Spacer()
            PlainButton(title: Strings.createAccount) {
                // Register User
            }
            .fontWeight(.heavy)
        }
    }
    
    private var backButton: some View {
        Button {
            publisher.resetFields()
        } label: {
            Image(systemName: "arrow.left")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
        }
        .padding()
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
