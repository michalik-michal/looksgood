import SwiftUI

struct BottomTabView: View {
    
    @State private var selectedIndex = 0
    @EnvironmentObject private var authService: AuthService
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color.whiteBlack)
    }
    
    var body: some View {
        if let user = authService.currentUser {
            switch user.accountType {
            case .user:
                HomeView()
            case .restaurantOwner:
                TabView(selection: $selectedIndex) {
                    HomeView()
                        .onAppear {
                            self.selectedIndex = 0
                        }
                        .tabItem {
                            Image(.map)
                            Text(Strings.map)
                        }.tag(0)
                    PlacePanelView()
                        .onAppear {
                            self.selectedIndex = 1
                        }
                        .tabItem {
                            Image(.house)
                            Text(Strings.panel)
                        }.tag(1)
                }
                .zIndex(20)
                .accentColor(.blackWhite)
            }
        } else {
            HomeView()
        }
    }
}

struct BottomTabView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTabView()
    }
}
