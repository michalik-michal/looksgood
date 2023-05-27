import SwiftUI

struct PlainLabelButton: View {
    
    var title: String
    var action: (() -> Void)
    
    var body: some View {
        Text(title)
            .foregroundColor(.black)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.black)
            }
            .onTapGesture(perform: action)
    }
}

struct PlainLabelButton_Previews: PreviewProvider {
    static var previews: some View {
        PlainLabelButton(title: "Hello") {
            //
        }
    }
}
