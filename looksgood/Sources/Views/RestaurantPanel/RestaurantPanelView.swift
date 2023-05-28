import SwiftUI

struct RestaurantPanelView: View {
    var body: some View {
        VStack() {
            LottieView(type: .hello)
                .frame(width: 350, height: 350)
            PlainButton(title: Strings.startAddingRestaurant) {
                //
            }
                .font(.title3)
        }
        .padding(.horizontal)
    }
}

struct RestaurantPanelView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantPanelView()
    }
}
