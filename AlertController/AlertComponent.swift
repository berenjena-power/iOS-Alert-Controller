import UIKit

protocol AlertComponent {
    var category: AlertComponentCategory { get }
    func getView(_ alert: UIView) -> UIView
}
