import SwiftUI

enum AlignmentType {
    case leading
    case center
}

struct PlainLabel: View {
    
    var title: String
    var alignment: AlignmentType
    var image: Image?
    
    init(title: String, alignment: AlignmentType = .center, image: Image? = nil) {
        self.title = title
        self.alignment = alignment
        self.image = image
    }
    
    var body: some View {
        if alignment == .center {
            HStack {
                image
                Text(title)
            }
            .foregroundColor(.blackWhite)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.blackWhite)
            }
        } else {
            HStack {
                image
                Text(title)
                    .foregroundColor(.blackWhite)
                    .frame(height: 50)
                    .contentShape(Rectangle())
                Spacer()
            }
            .padding(.horizontal)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.blackWhite)
            }
        }
    }
}

struct PlainLabel_Previews: PreviewProvider {
    static var previews: some View {
        PlainLabel(title: "Hello", alignment: .leading, image: Image(systemName: "phone"))
    }
}
