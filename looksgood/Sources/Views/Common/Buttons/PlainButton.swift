import SwiftUI

struct PlainButton: View {
    
    var title: String
    var action: (() -> Void)
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.blackWhite)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundColor(.blackWhite)
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
