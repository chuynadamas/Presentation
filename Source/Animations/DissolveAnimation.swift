import UIKit

public class DissolveAnimation: NSObject, Animatable {
  private let content: Content
  private let duration: TimeInterval
  private let delay: TimeInterval
  private var initial: Bool
  private var played = false
  private var isFadeIn = false

  public init(content: Content,
              duration: TimeInterval = 1.0,
              delay: TimeInterval = 0.0,
              initial: Bool = false,
              isFadeIn: Bool = false) {
      self.content = content
      self.duration = duration
      self.delay = delay
      self.initial = initial
      self.isFadeIn = isFadeIn
      content.view.alpha = 0.0

      super.init()
  }

  private func animate() {
    let alpha: CGFloat = content.view.alpha == 0.0 ? 1.0 : 0.0

    UIView.animate(
      withDuration: duration,
      delay: delay,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 0.5,
      options: [.beginFromCurrentState, .allowUserInteraction],
      animations: ({ [unowned self] in
        self.content.view.alpha = alpha
      }),
      completion: nil
    )

    played = true
  }
}

// MARK: - Animatable

extension DissolveAnimation {
    public func play() {
        if content.view.superview != nil {
            if !(initial && played) {
                content.view.alpha = (isFadeIn) ? 1.0 : 0.0
                animate()
            }
        }
    }
    
    public func playBack() {
        if content.view.superview != nil {
            if !(initial && played) {
                content.view.alpha = (isFadeIn) ? 0.0 : 1.0
                animate()
            }
        }
    }
    
    public func moveWith(offsetRatio: CGFloat) {
        let view = content.view
        if view.layer.animationKeys() == nil {
            if view.superview != nil {
                var ratio = offsetRatio > 0.0 ?  1 - offsetRatio : (0 - offsetRatio)
                if isFadeIn {
                    ratio = offsetRatio > 0.0 ? offsetRatio : (1.0 + (offsetRatio * 1.5))
                }
                view.alpha = ratio
            }
        }
    }
}

