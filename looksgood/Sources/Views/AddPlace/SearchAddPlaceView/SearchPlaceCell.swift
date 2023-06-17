import SwiftUI

struct SearchPlaceCell: View {
    
    var id: String
    var title: String
    var address: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2.bold())
                Spacer()
            }
            Text(address)
                .font(.title3)
            Divider()
        }
    }
}

struct SearchRestaurantCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchPlaceCell(id: "", title: "Pizza Paolo", address: "Kryspinow")
    }
}
