import SwiftUI

struct MenuView: View {
    
    @EnvironmentObject private var service: PlaceService
    @State private var showAddMenuItem = false
    @State private var selectedCategory: FoodCategory?
    
    var body: some View {
        VStack {
            if let categories = service.placeMenuCategories,
               let menuItems = service.menuItems {
                if !categories.isEmpty, !menuItems.isEmpty {
                    MenuItemCategoryStack(menuItemsCategories: categories,
                                          selectedCategory: $selectedCategory.safe(.All))
                    TabView(selection: $selectedCategory.safe(.All)) {
                        ForEach(categories, id: \.rawValue) { category in
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 0) {
                                    ForEach(menuItems, id: \.title) { item in
                                        if category == .All {
                                            MenuItemCell(menuItem: item)
                                        } else if item.category == category {
                                            MenuItemCell(menuItem: item)
                                        }
                                        
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
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        showAddMenuItem.toggle()
                    }
            }
        }
        .sheet(isPresented: $showAddMenuItem) {
            AddMenuItemSheet(isShowing: $showAddMenuItem)
                .presentationDetents([.height(600)])
        }
        .task {
            Task {
                try await service.fetchMenuItems()
                selectedCategory = service.placeMenuCategories?.first
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject( { () -> PlaceService in
                let object = PlaceService()
                object.usersPlace = Place(name: "Portobello",
                                          address: "Ul. Pod Wawelem 3b",
                                          rating: "4.2",
                                          phoneNumber: "123 456 789",
                                          website: "www.apple.com",
                                          placeCategory: .restaurant)
                object.menuItems = [
                    MenuItem(placeID: "", title: "Burger", price: "34USD", category: .Burger)
                ]
                return object
            }())
    }
}
