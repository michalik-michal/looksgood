import SwiftUI

struct DealsView: View {
    
    @ObservedObject private var publisher = SpecialOffersPublisher()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Strings.specialOffers)
                .font(.largeTitle).bold()
                .padding(.horizontal)
            ScrollView {
                VStack{
                    ForEach(publisher.specialOffers, id: \.self) { item in
                        NavigationLink {
                            PlaceView(placeID: item.placeID)
                                .backNavigationButton()
                        } label: {
                            MenuItemCell(menuItem: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .onAppear {
            Task {
                try await publisher.fetchSpecialOffers()
            }
        }
    }
}

struct DealsView_Previews: PreviewProvider {
    static var previews: some View {
        DealsView()
    }
}
