import SwiftUI

struct SystemImage: View {
    
    var image: SystemImageType
    
    init(_ image: SystemImageType) {
        self.image = image
    }
    
    var body: some View {
        Image(systemName: image.rawValue)
            .resizable()
    }
}

struct SystemImage_Previews: PreviewProvider {
    static var previews: some View {
        SystemImage(.person)
    }
}
