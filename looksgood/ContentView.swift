import SwiftUI

struct ContentView: View {
        
    var body: some View {
        BottomTabView()
            .foregroundColor(.blackWhite)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//TODO: - add multiple photos for restaurant
//TODO: - Handle ingredients and possibly description
//TODO: - Handle ratings
//TODO: - Handle adding place manually
//TODO: - Add place to favourites
//TODO: - Login after creating account
