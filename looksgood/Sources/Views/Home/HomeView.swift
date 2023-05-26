import MapKit
import SwiftUI

struct HomeView: View {
    
    
    var body: some View {
        ZStack {
            MapView()
        }
        .ignoresSafeArea()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
