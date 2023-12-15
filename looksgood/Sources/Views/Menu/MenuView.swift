import SwiftUI

struct MenuView: View {
    
    var placeID: String
    @EnvironmentObject private var placeService: PlaceService

    @State private var menuItems: [MenuItem] = []
    @State private var menuCategories: [FoodCategory] = []
    @State private var selectedCategory: FoodCategory?
    
    var body: some View {
        VStack {
            if menuCategories.isNotEmpty, menuItems.isNotEmpty {
                MenuItemCategoryStack(menuItemsCategories: menuCategories,
                                      selectedCategory: $selectedCategory.safe(.All))
                TabView(selection: $selectedCategory.safe(.All)) {
                    ForEach(menuCategories, id: \.rawValue) { category in
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach(menuItems, id: \.title) { item in
                                    NavigationLink {
                                        MenuItemDetailsView(menuItem: item, ownerView: false)
                                            .backNavigationButton()
                                    } label: {
                                        if category == .All {
                                            MenuItemCell(menuItem: item)
                                        } else if item.category == category {
                                            MenuItemCell(menuItem: item)
                                        }
                                    }
                                    .buttonStyle(FullOpacity())
                                }
                            }
                        }
                        .tag(category)
                    }
                }
                .frame(height: UIScreen.main.bounds.height - 250)
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
        .onAppear {
            Task {
                menuItems = try await placeService.fetchMenuItems(with: placeID) ?? []
                menuCategories = placeService.retreiveCategories(for: menuItems)
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(placeID: "")
    }
}
