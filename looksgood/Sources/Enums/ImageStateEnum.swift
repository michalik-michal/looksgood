import SwiftUI

enum ImageState: Equatable {
    case loading
    case success(Image)
    case failure
    case empty
}
