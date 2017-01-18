import UIKit
import Cartography
import QuartzCore
import ReactiveSwift
import ReactiveCocoa
import Result

class HeaderAlertComponent: AlertComponent {
    enum UserAction {
        case closeButtonTapped
    }
    
    let userActionsSignal: Signal<UserAction, NoError>
    private var userActionsObserver: Observer<UserAction, NoError>
    
    init(showCloseButton: Bool) {
        self.showCloseButton = showCloseButton
        
        (userActionsSignal, userActionsObserver) = Signal<UserAction, NoError>.pipe()
    }
    
    var category = AlertComponentCategory.header
    
    func getView(_ alert: UIView) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        if (showCloseButton) {
            let closebutton = UIButton()
            closebutton.setImage(UIImage(named: "icn_close_red"), for: .normal)
            closebutton.setTitleColor(.fromHex("EC0000"), for: .normal)
            closebutton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
            
            headerView.addSubview(closebutton)
            constrain(headerView, closebutton) { headerView, closebutton in
                
                closebutton.top == headerView.top + 4
                closebutton.trailing == headerView.trailing - 4
                closebutton.height == 40
                closebutton.width == 40
            }
        }
    
        constrain(headerView) { headerView in
            
            headerView.height == 30
        }
        
        return headerView
    }
    
    @objc
    func closeButtonTapped() {
        userActionsObserver.send(value: .closeButtonTapped)
    }
    
    //MARK: Private
    
    private let showCloseButton: Bool
}
