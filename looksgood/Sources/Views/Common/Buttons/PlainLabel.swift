import SwiftUI

enum AlignmentType {
    case leading
    case center
}

enum ImagePlacement {
    case left
    case right
}

struct PlainLabel: View {
    
    var title: String
    var alignment: AlignmentType
    var image: Image?
    var imagePlacement: ImagePlacement?
    
    init(title: String,
         alignment: AlignmentType = .center,
         image: Image? = nil,
         imagePlacement: ImagePlacement = .left) {
        self.title = title
        self.alignment = alignment
        self.image = image
        self.imagePlacement = imagePlacement
    }
    
    var body: some View {
        if alignment == .center {
            if imagePlacement == .left {
                HStack {
                    image
                    Text(title)
                }
                .foregroundColor(.blackWhite)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .lineLimit(1)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.blackWhite)
                }
            } else {
                HStack {
                    Text(title)
                    image
                }
                .foregroundColor(.blackWhite)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .lineLimit(1)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.blackWhite)
                }
            }
        } else {
            HStack {
                image
                Text(title)
                    .foregroundColor(.blackWhite)
                    .frame(height: 50)
                    .contentShape(Rectangle())
                    .lineLimit(1)
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
        PlainLabel(title: "Hello", alignment: .leading, image: Image(.phone))
    }
}
