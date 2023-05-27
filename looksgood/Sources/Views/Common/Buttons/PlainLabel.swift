import SwiftUI

enum AlignmentType {
    case leading
    case center
}

struct PlainLabel: View {
    
    var title: String
    var alignment: AlignmentType
    
    init(title: String, alignment: AlignmentType = .center) {
        self.title = title
        self.alignment = alignment
    }
    
    var body: some View {
        if alignment == .center {
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
        } else {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                    .frame(height: 50)
                    .contentShape(Rectangle())
                    .padding(.horizontal)
                Spacer()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.black)
            }
        }
    }
}

struct PlainLabel_Previews: PreviewProvider {
    static var previews: some View {
        PlainLabel(title: "Hello")
    }
}
