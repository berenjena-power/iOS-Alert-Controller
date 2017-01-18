import UIKit
import Cartography
import ReactiveCocoa
import Helpers

public enum AlertUserAction {
    case dismissButtonTapped
    case primaryButtonTapped
    case secondaryButtonTapped
}

public struct AlertResponse {
    public let alertUserActionType: AlertUserAction
    let alert: AlertViewController
    
    func dismissAlert(animated: Bool, completion: (() -> Void)?) {
        alert.dismiss(animated: animated, completion: completion)
    }
}

enum AlertComponentCategory: Int {
    case header = 0, body = 1, footer = 2
}

class AlertViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    
    var components: [AlertComponent] = []
    
    init(animationDirection: AnimationDirection) {
        self.animationDirection = animationDirection
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        buildView()
    }
    
    func dismissAndRestoreWindow(_ applicationRootWindow: UIWindow, completion: (() -> ())? = nil) {
        dismiss(animated: true, completion: {
            self.view.window?.rootViewController = nil
            self.view.window?.removeFromSuperview()
            applicationRootWindow.makeKeyAndVisible()
            completion?()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setCenterYConstraint(size.height / 2)
    }
    
    //MARK: UIViewControllerTransitioningDelegate Methods
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented == self {
            return AlertPresentationController(presentedViewController: presented, presenting: presenting)
        }
        
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented == self {
            return AlertAnimationController(isPresenting: true, animationDirection: animationDirection)
        }
        
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed == self {
            return AlertAnimationController(isPresenting: false, animationDirection: animationDirection)
        }
        
        return nil
    }
    
    //MARK: Private methods
    private let animationDirection: AnimationDirection
    private var rootStackView: UIStackView!
    private var containerView: UIView!
    private var centerYConstraint: NSLayoutConstraint? = nil
    
    private func buildView() {
        var views: [UIView] = []
        
        components.forEach {
            views.append($0.getView(self.view))
        }
        
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.borderColor = UIColor.red.cgColor
        containerView.layer.borderWidth = 1.0

        rootStackView = UIStackView(arrangedSubviews: views)
        rootStackView.distribution = .fill
        rootStackView.alignment = .fill
        rootStackView.axis = .vertical
        rootStackView.clipsToBounds = true
        
        view.addSubview(containerView)
        view.addSubview(rootStackView)
        
        constrain(containerView, rootStackView) { containerView, stackView in
            containerView.height == stackView.height + 2
            containerView.width == stackView.width + 2
            containerView.leading == stackView.leading - 1
            containerView.top == stackView.top - 1
        }
        
        let viewHalfHeight = self.view.bounds.height / 2
        constrain(rootStackView, view) { stackView, view in
            
            (stackView.bottom == view.bottom - 60) ~ 750.0
            
            (stackView.leading == view.leading + 40) ~ 800.0
            (stackView.trailing == view.trailing - 40) ~ 800.0
            (stackView.width <= 350) ~ 1000.0
            (stackView.width == 350) ~ 750.0
            
            (stackView.centerX == view.centerX) ~ 1000.0
        }
        
        setCenterYConstraint(viewHalfHeight)
    }
    
    private func setCenterYConstraint(_ viewHalfHeight: CGFloat) {
        
        if let centerYConstraint = centerYConstraint {
            rootStackView.removeConstraint(centerYConstraint)
            view.removeConstraint(centerYConstraint)
        }
        
        constrain(rootStackView, view) {
            stackView, view in
            
            centerYConstraint = stackView.centerY == view.centerY
            centerYConstraint = stackView.centerY == (view.top + viewHalfHeight.ceilValue)
        }
    }
}
