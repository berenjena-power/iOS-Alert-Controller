import UIKit
import Cartography
import QuartzCore

public class IconAlertComponent: AlertComponent {
    public enum IconType: String {
        case error = "icn_alert_error"
        case info = "icn_alert_info"
        case success = "icn_alert_success"
        case alert = "icn_alert"
    }
    
    init(iconType: IconType) {
        self.iconType = iconType
    }
    
    var category = AlertComponentCategory.body
    
    func getView(_ alert: UIView) -> UIView {
        let headerView = UIView()

        guard let iconImage = UIImage(named: iconType.rawValue) else {
            return headerView
        }
        
        let iconImageView = UIImageView(image: iconImage)
        iconImageView.contentMode = .center
        
        headerView.addSubview(iconImageView)
        constrain(headerView, iconImageView) {
            headerView, iconImageView in
            
            iconImageView.top <= headerView.top + 10
            iconImageView.bottom >= headerView.bottom - 10
            iconImageView.leading == headerView.leading + 30
            iconImageView.trailing == headerView.trailing - 30
        }
        
        constrain(headerView) {
            headerView in
            
            headerView.height == iconImage.size.height + 20
        }
        
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    //MARK: Private
    
    private let iconType: IconType
}
