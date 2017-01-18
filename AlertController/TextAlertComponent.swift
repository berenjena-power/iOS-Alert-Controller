import Foundation
import UIKit
import Cartography

extension TextAlertComponent {
    static func build(title: String, text: String) -> TextAlertComponent {
        let textComponent = TextAlertComponent()
        
        let centerParagraphStyle = NSMutableParagraphStyle()
        centerParagraphStyle.alignment = .center
        
        let titleAttributes = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18),
            NSForegroundColorAttributeName : UIColor.fromHex("EC0000"),
            NSParagraphStyleAttributeName : centerParagraphStyle
        ]
        let tittleAttributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)
        textComponent.appendAttributedText(tittleAttributedText)
        
        if text.length > 0 {
            let textAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName : UIColor.fromHex("adadad"),
                NSParagraphStyleAttributeName : centerParagraphStyle
            ]
            let textAttributedText = NSAttributedString(string: "\n\n" + text, attributes: textAttributes)
            textComponent.appendAttributedText(textAttributedText)
        }
        
        return textComponent
    }
}

class TextAlertComponent: NSObject, AlertComponent, UITextViewDelegate {
    
    var category = AlertComponentCategory.body
    
    override init() {
        texts = []
    }
    
    func getView(_ alert: UIView) -> UIView {
        
        let textView = UITextView()
        let fullText = NSMutableAttributedString()
        for text in texts {
            fullText.append(text)
        }
        
        textView.attributedText = fullText
        textView.isEditable = false
        textView.isSelectable = true
        textView.delegate = self
        
        let margins = textView.layoutMargins
        let topInset: CGFloat = 20
        let lateralInset: CGFloat = 10
        textView.contentInset.top = topInset
        textView.textContainerInset.left = lateralInset
        textView.textContainerInset.right = lateralInset
        let textSize = textView.sizeThatFits(CGSize(width: alert.bounds.width, height: maxTextComponentHeight))
        let textViewHeight = ceil(textSize.height + margins.top + margins.bottom + topInset) + 1
        
        constrain(textView) {
            textView in
            
            textView.height >= 50
            textView.height <= textViewHeight
        }
        
        textView.backgroundColor = .clear
        
        return textView
    }
    
    func appendStringText(_ text: String) {
        texts.append(NSAttributedString(string: text))
    }
    
    func appendAttributedText(_ attributedText: NSAttributedString) {
        texts.append(attributedText)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return true
    }
    
    //MARK: Private
    
    private var texts: [NSAttributedString]
    private let maxTextComponentHeight: CGFloat = 150
}
