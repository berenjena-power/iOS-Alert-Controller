import UIKit
import Helpers

class AlertAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    let isPresenting: Bool
    let presentDuration: TimeInterval = 0.5
    let dismissDuration: TimeInterval = 0.75
    
    fileprivate let animationDirection: AnimationDirection
    
    init(isPresenting: Bool, animationDirection: AnimationDirection) {
        self.isPresenting = isPresenting
        self.animationDirection = animationDirection
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if isPresenting {
            return presentDuration
        }
        
        return dismissDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            presentAnimateTransition(transitionContext)
        } else {
            dismissAnimateTransition(transitionContext)
        }
    }
    
    func presentAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let containerView = transitionContext.containerView
        containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        
        if case .fromBottom(let bottomMargin) = animationDirection {
            presentedControllerView.transform = CGAffineTransform(translationX: 0, y: bottomMargin)
        } else if case .fromTop(let topMargin) = animationDirection {
            presentedControllerView.transform = CGAffineTransform(translationX: 0, y: -topMargin)
        }
        
        containerView.addSubview(presentedControllerView)
        presentedControllerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Animate the presented view to it's final position
        UIView.animate(withDuration: presentDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            presentedControllerView.transform = CGAffineTransform.identity
            }, completion: { completed in
                transitionContext.completeTransition(completed)
        })
    }
    
    func dismissAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        UIView.animate(withDuration: dismissDuration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            if case .fromBottom(let bottomMargin) = self.animationDirection {
                presentedControllerView.transform = CGAffineTransform(translationX: 0, y: bottomMargin)
            } else if case .fromTop(let topMargin) = self.animationDirection {
                presentedControllerView.transform = CGAffineTransform(translationX: 0, y: 3 * -topMargin)
            }
            }, completion: { completed in
                transitionContext.completeTransition(completed)
        })
    }
}

