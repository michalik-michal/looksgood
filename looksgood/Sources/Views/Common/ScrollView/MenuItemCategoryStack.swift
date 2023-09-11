
import SwiftUI

struct MenuItemCategoryStack: View {
    
    var menuItemsCategories: [FoodCategory]
    @Binding var selectedCategory: FoodCategory
    @Namespace var animation
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(menuItemsCategories, id: \.rawValue) { item in
                        VStack {
                            Text(item == .specialOffer ? "⭐ \(item.rawValue)" : item.rawValue)
                                .font(.subheadline)
                                .fontWeight(selectedCategory == item ? .bold : .regular)
                                .frame(maxWidth: .infinity)
                            if selectedCategory == item {
                                Capsule()
                                    .foregroundColor(.blackWhite)
                                    .frame(height: 3)
                                    .matchedGeometryEffect(id: "filter", in: animation)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Capsule()
                                    .foregroundColor(.clear)
                                    .frame(height: 3)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(minWidth: 70)
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                self.selectedCategory = item
                            }
                        }
                    }
                }
            }
        }
        .overlay {
            Divider()
                .offset(y: 16)
                .padding(.trailing, 30)
        }
    }
}

struct MenuItemCategoryStack_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemCategoryStack(menuItemsCategories: [.All], selectedCategory: .constant(.All))
    }
}
