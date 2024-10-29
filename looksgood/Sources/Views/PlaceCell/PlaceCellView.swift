import SwiftUI

struct PlaceCellView: View {
    
    var place: Place
    
    var body: some View {
            NavigationLink {
                if let placeID = place.id {
                    PlaceView(placeID: placeID)
                        .backNavigationButton()
                }
            } label: {
                VStack(alignment: .leading) {
                    if let imageURL = place.imageURLs?.first, imageURL.isNotEmptyString {
                        asyncImage(url: imageURL)
                    }
                    VStack {
                        titleStack
                            .padding(.top, place.imageURLs?.first == "" ? 10 : 0)
                        adressStack
                        secondaryStack
                            .padding(.bottom, 10)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            .buttonStyle(PlainButtonStyle())
    }
    
    private func asyncImage(url: String) -> some View {
        return AsyncImage(url: URL(string: url)) { image in
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
                .foregroundColor(.blackWhite)
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
            Text(place.address ?? "")
                .foregroundColor(.gray)
            Spacer()
        }
    }

    private var secondaryStack: some View {
        HStack {
            PlaceCategoryCell(placeCategory: PlaceCategory(type: place.placeCategory))
            Spacer()
            Text("10:00 - 23:00")
                .foregroundColor(.gray)
                .bold()
        }
    }
}

struct PlaceCellView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCellView(place: Place(name: "Portobello",
                                   address: "Juliusza Lea 16A",
                                   placeCategory: .salaZabaw))
    }
}
