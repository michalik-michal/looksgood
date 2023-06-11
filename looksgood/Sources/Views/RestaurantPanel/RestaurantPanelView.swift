import SwiftUI

struct RestaurantPanelView: View {
    
    @ObservedObject private var placesManager = PlacesService()
    @State private var showAddManuallyView = false
    @State private var showAddWithGoogle = false
    @State private var selectedMethod: AddRestauranMethod?
    
    var body: some View {
        NavigationView {
            VStack() {
                LottieView(type: .hello)
                    .frame(width: 350, height: 350)
                HStack {
                    Text("Start adding place")
                        .font(.title.bold())
                    Spacer()
                }
                PlainLabelButton(title: "Search on GoogleMaps") {
                    Impact().makeImpact(.medium)
                    selectedMethod = .googleMaps
                }
                .bold(selectedMethod == .googleMaps)
                Text(Strings.or)
                    .font(.title3.bold())
                PlainLabelButton(title: "Add manually") {
                    Impact().makeImpact(.medium)
                    selectedMethod = .manual
                }
                .bold(selectedMethod == .manual)
                Spacer()
                Button {
                    switch selectedMethod {
                    case .manual:
                        showAddManuallyView.toggle()
                    case .googleMaps:
                        showAddWithGoogle.toggle()
                    default:
                        return
                    }
                } label: {
                    PlainLabel(title: Strings.go)
                }
                .font(.title3)
                .padding(.bottom)
                .hide(if: selectedMethod == nil)
            }
            .padding(.horizontal)
            .fullScreenCover(isPresented: $showAddManuallyView) {
                NavigationModalBarView(showModal: $showAddManuallyView,
                                       content: AddPlaceView(showRatingField: false))
            }
            .fullScreenCover(isPresented: $showAddWithGoogle) {
                NavigationModalBarView(showModal: $showAddWithGoogle,
                                       content: SearchAddRestaurantView())
            }
        }
    }
}

struct RestaurantPanelView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantPanelView()
    }
}
