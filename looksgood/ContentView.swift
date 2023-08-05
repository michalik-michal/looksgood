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
//TODO: - Fetch restaurant photo, add multiple photos
//TODO: Handle ingredients and possibly description
