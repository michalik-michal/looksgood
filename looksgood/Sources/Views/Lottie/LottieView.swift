import SwiftUI
import UIKit
import Lottie

struct LottieView: UIViewRepresentable {
    
    var type: animationType
    typealias UIViewType = UIView
    
    enum animationType: String {
        case bunchOfFood
        case phone
        case confirmingOrder
    }

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)

        let animationView = LottieAnimationView()

        animationView.animation = LottieAnimation.named(type.rawValue)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        return view
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {}
}
