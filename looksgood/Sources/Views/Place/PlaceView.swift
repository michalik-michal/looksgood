import SwiftUI

struct PlaceView: View {
    
    @EnvironmentObject private var placeService: PlaceService
    var placeID: String
    @State private var place = Place(name: "", placeCategory: .restaurant)

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if let imageURL = place.imageURL {
                    asyncImage(url: imageURL)
                }
                VStack {
                    titleStack
                    adressStack
                    secondaryStack
                    NavigationLink {
                        MenuView(placeID: placeID)
                            .backNavigationButton()
                    } label: {
                        PlainLabel(title: "Menu",
                                   alignment: .leading,
                                   image: Image(.book))
                    }
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            Task {
                if let fetchedPlace = try await placeService.fetchPlace(with: placeID) {
                    place = fetchedPlace
                }
            }
        }
    }
    
    private func asyncImage(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .frame(height: 180)
        } placeholder: {
            ProgressView()
                .frame(width: UIScreen.main.bounds.width,
                       height: 180)
        }
    }

    private var titleStack: some View {
        HStack {
            Text(place.name)
                .font(.title.bold())
                .foregroundColor(.black)
            Spacer()
            if let rating = place.rating {
                HStack {
                    Image(.starFill)
                        .resizable()
                        .foregroundColor(.yellow)
                        .frame(width: 15, height: 15)
                    Text(rating)
                        .foregroundColor(.gray)
                        .bold()
                    Text("(149)")
                        .foregroundColor(.gray)
                    Image("google")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding(.top, 3)
                .onTapGesture {
                    let link = "https://goo.gl/maps/bJMtrxCDRBzPYjPH7"
                    UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                }
            }
            
        }
    }

    private var adressStack: some View {
        HStack {
            Text(place.address ?? "Add address")
                .foregroundColor(.gray)
            Spacer()
            Text("10:00 - 23:00")
                .foregroundColor(.gray)
                .bold()
        }
    }

    private var secondaryStack: some View {
        HStack {
            PlaceCategoryCell(placeCategory: PlaceCategory(category: "Restaurant",
                                                           image: "house",
                                                           type: .restaurant))
            Spacer()
        }
        .padding(.bottom)
    }
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView(placeID: "")
    }
}
