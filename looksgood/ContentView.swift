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
//TODO: - Handle adding opeing hours manually
//TODO: - Handle ingredients and possibly description
//TODO: - Handle ratings
//TODO: - Handle adding place manually
//TODO: - Add place to favourites
//TODO: - Login after creating account
//TODO: - Edit properties (phone, website)
//TODO: - Display Website for user ?
//TODO: - Special offers in the menu -> Previous price
//TODO: - Map search view
