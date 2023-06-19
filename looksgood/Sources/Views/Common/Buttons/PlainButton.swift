import SwiftUI

struct PlainButton: View {
    
    var title: String
    var action: (() -> Void)
    var image: Image?
    
    init(title: String, image: Image? = nil, action: @escaping () -> Void) {
        self.title = title
        self.action = action
        self.image = image
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                image
                Text(title)
            }
            .foregroundColor(.blackWhite)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
        }
        .background(Color.whiteBlack)
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
