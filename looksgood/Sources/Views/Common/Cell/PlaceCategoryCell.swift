import SwiftUI

struct PlaceCategoryCell: View {

    var placeCategory: PlaceCategory

    var body: some View {
        HStack(spacing: 3) {
            Image(systemName: placeCategory.image)
            Text(placeCategory.category)
        }
        .foregroundColor(.whiteBlack)
        .padding(8)
        .frame(height: 33)
        .background(PlaceCategories().colorProvider(placeCategory.type).gradient)
        .cornerRadius(20)
        .font(.footnote)
    }
}

struct PlaceCategoryCell_Previews: PreviewProvider {
    static var previews: some View {
        PlaceCategoryCell(placeCategory: PlaceCategory(category: "Drinks",
                                                       image: "wineglass",
                                                       type: .drinks))
    }
}
