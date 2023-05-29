import SwiftUI
import GooglePlaces

struct PlaceRow: View {
    var place: GMSPlace
    
    var body: some View {
        HStack {
            Text(place.name ?? "")
                .foregroundColor(.white)
            Spacer()
        }
    }
}

//struct PlaceRow_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceRow()
//    }
//}
