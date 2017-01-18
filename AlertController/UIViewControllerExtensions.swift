import Foundation
import ReactiveSwift
import Result

public extension UIViewController {
    public func presentAlert(title: String, subtitle: String = "", buttonTitle: String, secondaryButtonTitle: String = "", showClose: Bool = true, iconType: IconAlertComponent.IconType = .success) -> SignalProducer<AlertResponse, NoError> {
        return SignalProducer { observer, disposable in
            
            let alertController = AlertViewController(animationDirection: .fromTop(topMargin: UIScreen.main.bounds.height / 2.0))
            
            if showClose {
                let headerComponent = HeaderAlertComponent(showCloseButton: true)
                headerComponent.userActionsSignal
                    .observe(on: UIScheduler())
                    .observeValues { value in
                        observer.send(value: AlertResponse(userAction: .closeButtonTapped, alert: alertController))
                }
                alertController.components.append(headerComponent)
            }
            
            alertController.components.append(IconAlertComponent(iconType: iconType))
            let textComponent = TextAlertComponent.build(title: title, text: subtitle)
            alertController.components.append(textComponent)
            
            let primaryButton = FooterButtonComponent.FooterButton(title: buttonTitle)
            let secondaryButton = FooterButtonComponent.FooterButton(title: secondaryButtonTitle)
            
            if secondaryButtonTitle == "" {
                let buttonComponent = FooterButtonComponent(primaryButton: primaryButton)
                alertController.components.append(buttonComponent)
                
                buttonComponent.userActionsSignal
                    .observe(on: UIScheduler())
                    .observeValues { value in
                        observer.send(value: AlertResponse(userAction: .primaryButtonTapped, alert: alertController))
                        observer.sendCompleted()
                }
            } else {
                let buttonComponent = FooterButtonComponent(primaryButton: primaryButton, secondaryButton: secondaryButton)
                alertController.components.append(buttonComponent)
                
                buttonComponent.userActionsSignal
                    .observe(on: UIScheduler())
                    .observeValues { value in
                        switch value {
                        case .primaryButtonTapped:
                            observer.send(value: AlertResponse(userAction: .primaryButtonTapped, alert: alertController))
                        case .secondaryButtonTapped:
                            observer.send(value: AlertResponse(userAction: .secondaryButtonTapped, alert: alertController))
                        }
                        observer.sendCompleted()
                }
            }
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
