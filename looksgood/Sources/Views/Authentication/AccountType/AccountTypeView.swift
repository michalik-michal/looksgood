import SwiftUI

struct AccountTypeView: View {
    
    @State private var selectedType: AccountType?
    @ObservedObject private var publisher = AccountTypePublisher()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack() {
            LottieView(type: .phone)
                .frame(width: 350, height: 350)
            HStack {
                Text(selectedType == nil ? Strings.whoAreYou : publisher.convertUserType(selectedType!))
                    .font(.title.bold())
                Spacer()
            }
            PlainLabelButton(title: Strings.restaurantOwner) {
                Impact().makeImpact(.medium)
                selectedType = .restaurantOwner
            }
            .fontWeight(selectedType == .restaurantOwner ? .bold : .regular)
            Text(Strings.or)
                .font(.title3.bold())
            PlainLabelButton(title: Strings.user) {
                Impact().makeImpact(.medium)
                selectedType = .user
            }
            .fontWeight(selectedType == .user ? .bold : .regular)
            Spacer()
            if let account = selectedType {
                NavigationLink {
                    RegisterView(accountType: account)
                } label: {
                    PlainLabel(title: Strings.next)
                }
                .fontWeight(.heavy)
            }
        }
        .padding(.horizontal)
        .backNavigationButton()
    }
}

struct AccountTypeView_Previews: PreviewProvider {
    static var previews: some View {
        AccountTypeView()
    }
}
