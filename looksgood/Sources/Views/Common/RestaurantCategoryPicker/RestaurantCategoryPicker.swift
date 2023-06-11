import SwiftUI

struct RestaurantCategoryPicker: View {
    
    let categories = PlaceCategories()
    @Binding var selectedCategory: PlaceCategoriesEnum?
    
    let rows = [
            GridItem(.fixed(30), alignment: .leading),
            GridItem(.fixed(30), alignment: .leading)]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(categories.placeCategories, id:\.type.rawValue) { item in
                    PlaceCategoryCell(placeCategory: item)
                        .fontWeight(selectedCategory == item.type ? .heavy : .regular)
                        .onTapGesture {
                            Impact().makeImpact(.medium)
                            selectedCategory = item.type
                        }
                }
            }
        }
    }
}

struct RestaurantCategoryPicker_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCategoryPicker(selectedCategory: .constant(.drinks))
    }
}
