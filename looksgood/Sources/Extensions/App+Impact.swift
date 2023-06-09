import UIKit

class Impact {
    let softImpact = UIImpactFeedbackGenerator(style: .soft)
    let lightImpact = UIImpactFeedbackGenerator(style: .light)
    let rigidImpact = UIImpactFeedbackGenerator(style: .rigid)
    let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    let heavyimpact = UIImpactFeedbackGenerator(style: .heavy)
    
    func makeImpact(_ impact: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: impact).impactOccurred()
    }
    
}
