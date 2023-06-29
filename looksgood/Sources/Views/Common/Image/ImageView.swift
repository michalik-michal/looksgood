import SwiftUI

struct ImageView: View {
    
    var imageName: String?
    var image: Image?
    var height: CGFloat
    
    init(imageName: String? = nil, image: Image? = nil, height: CGFloat) {
        self.imageName = imageName
        self.height = height
    }

    var body: some View {
        if let imageName = imageName {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: height)
                .clipped()
        }
        if let image = image {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: height)
                .clipped()
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(imageName: "restaurant", height: 180)
    }
}
