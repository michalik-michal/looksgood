import SwiftUI

struct MapSearchField: View {
        
    @Binding var text: String
    @State private var showProfileView = false
    
    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(.leading)
            Divider()
                .frame(height: 22)
            SystemImage(.person)
                .frame(width: 15, height: 15)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)
                .onTapGesture {
                    showProfileView.toggle()
                }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.3), radius: 20, y: 5)
        .fullScreenCover(isPresented: $showProfileView) {
            NavigationModalBarView(showModal: $showProfileView, content: ProfileView())
        }
    }
}

struct MapSearchField_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchField(text: .constant(""))
    }
}
