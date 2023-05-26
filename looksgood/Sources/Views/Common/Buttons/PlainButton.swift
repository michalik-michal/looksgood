import SwiftUI

struct PlainButton: View {
    
    var title: String
    var action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(.black)
        }
    }
}

struct PlainButton_Previews: PreviewProvider {
    static var previews: some View {
        PlainButton(title: "Lets go!") {
            print("")
        }
    }
}
