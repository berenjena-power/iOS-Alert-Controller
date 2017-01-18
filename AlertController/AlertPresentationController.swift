import UIKit

class AlertPresentationController: UIPresentationController {
    lazy var dimmingView: UIVisualEffectView = {
        return UIVisualEffectView(frame: self.containerView!.bounds)
    }()
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = (containerView?.bounds)!
        containerView?.addSubview(dimmingView)
        containerView?.addSubview(presentedView!)
        
        dimmingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView.effect = UIBlurEffect(style: .dark)
                }, completion: nil)
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let transitionCoordinator = presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { _ in
                self.dimmingView.effect = nil
                }, completion: nil)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
}
