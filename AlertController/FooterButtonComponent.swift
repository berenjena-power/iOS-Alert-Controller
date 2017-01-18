import UIKit
import Cartography
import QuartzCore
import ReactiveSwift
import Result

class FooterButtonComponent: AlertComponent {
    enum UserAction {
        case primaryButtonTapped
        case secondaryButtonTapped
    }
    
    let userActionsSignal: Signal<UserAction, NoError>
    private var userActionsObserver: Observer<UserAction, NoError>
    
    struct FooterButton {
        let title: String
    }
    
    init(primaryButton: FooterButton, secondaryButton: FooterButton? = nil) {
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
        
        (userActionsSignal, userActionsObserver) = Signal<UserAction, NoError>.pipe()
    }
    
    var category = AlertComponentCategory.footer
    
    func getView(_ alert: UIView) -> UIView {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        
        if let secondaryButton = secondaryButton {
            //Two buttons:
            let leftButton = UIButton(type: .custom)
            leftButton.setTitle(primaryButton.title, for: .normal)
            leftButton.setTitleColor(.fromHex("EC0000"), for: .normal)
            leftButton.setTitleColor(.fromHex("800000"), for: .highlighted)
            leftButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)

            let rightButton = UIButton(type: .custom)
            rightButton.setTitle(secondaryButton.title, for: .normal)
            rightButton.setTitleColor(.fromHex("EC0000"), for: .normal)
            rightButton.setTitleColor(.fromHex("800000"), for: .highlighted)
            rightButton.addTarget(self, action: #selector(secondaryButtonTapped), for: .touchUpInside)

            if let leftTitleLabel = leftButton.titleLabel, let rightTitleLabel = rightButton.titleLabel {
                leftTitleLabel.numberOfLines = 0
                leftTitleLabel.lineBreakMode = .byWordWrapping
                leftTitleLabel.textAlignment = .center
                leftTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)

                rightTitleLabel.numberOfLines = 0
                rightTitleLabel.lineBreakMode = .byWordWrapping
                rightTitleLabel.textAlignment = .center
                rightTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
            }
            
            footerView.addSubview(leftButton)
            footerView.addSubview(rightButton)
            
            constrain(leftButton, rightButton) { leftButton, rightButton in
                leftButton.width == rightButton.width
                leftButton.height == rightButton.height
                
                leftButton.top == leftButton.superview!.top
                leftButton.leading == leftButton.superview!.leading
                leftButton.bottom == leftButton.superview!.bottom
                leftButton.width == leftButton.superview!.width / 2
                
                rightButton.top == rightButton.superview!.top
                rightButton.trailing == rightButton.superview!.trailing
                rightButton.bottom == rightButton.superview!.bottom
            }
            
            let topLineView = UIView()
            topLineView.backgroundColor = .fromHex("d7d7d7")
            
            footerView.addSubview(topLineView)
            
            constrain(topLineView, footerView) { topLineView, footerView in
                topLineView.top == footerView.top
                topLineView.leading == footerView.leading + 5
                topLineView.trailing == footerView.trailing - 5
                topLineView.height == 1
            }
            
            let separatorLineView = UIView()
            separatorLineView.backgroundColor = .fromHex("d7d7d7")
            
            footerView.addSubview(separatorLineView)
            
            constrain(separatorLineView, footerView) { separatorLineView, footerView in
                separatorLineView.top == footerView.top
                separatorLineView.bottom == footerView.bottom - 5
                separatorLineView.width == 1
                separatorLineView.centerX == footerView.centerX
            }
        } else {
            //One button:
            let centerButton = UIButton(type: .custom)
            centerButton.setTitleColor(.fromHex("EC0000"), for: .normal)
            centerButton.setTitleColor(.fromHex("800000"), for: .highlighted)
            centerButton.setTitle(primaryButton.title, for: .normal)
            centerButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)

            if let titleLabel = centerButton.titleLabel {
                titleLabel.numberOfLines = 1
                titleLabel.adjustsFontSizeToFitWidth = true
                titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
            }
            
            footerView.addSubview(centerButton)
            
            constrain(centerButton, footerView) { centerButton, footerView in
                centerButton.width == footerView.width
                centerButton.height == footerView.height
                
                centerButton.top == footerView.top
                centerButton.leading == footerView.leading
            }
            
            let lineView = UIView()
            lineView.backgroundColor = .fromHex("d7d7d7")
            
            footerView.addSubview(lineView)
            
            constrain(lineView, footerView) { lineView, footerView in
                lineView.top == footerView.top
                lineView.leading == footerView.leading + 5
                lineView.trailing == footerView.trailing - 5
                lineView.height == 1
            }
        }
        
        constrain(footerView) { footerView in
            footerView.height == (secondaryButton == nil ? 40 : 60)
        }
        
        return footerView
    }
    
    //MARK: Private
    
    private let primaryButton: FooterButton
    private let secondaryButton: FooterButton?
    
    @objc
    private func primaryButtonTapped() {
        userActionsObserver.send(value: .primaryButtonTapped)
    }

    @objc
    private func secondaryButtonTapped() {
        userActionsObserver.send(value: .secondaryButtonTapped)
    }
}
