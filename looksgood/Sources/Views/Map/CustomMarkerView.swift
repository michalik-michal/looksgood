import SwiftUI

struct CustomMarkerView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
        }
        .frame(width: 100, height: 100)
        .background(.black)
    }
}

struct CustomMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomMarkerView()
    }
}
