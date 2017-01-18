# iOS-Alert-Controller

<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift3-compatible-4BC51D.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
<a href="https://raw.githubusercontent.com/xmartlabs/XLSwiftKit/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

## Introduction


# Configuration

TBD

# Usage

To integrate Alert Controller into your Xcode project using Carthage, specify it in your `Cartfile`:
```ogdl
github "sebastianvarela/iOS-Alert-Controller" 
```

In any UIViewController, add the imports:
```Swift
import AlertController
import ReactiveSwift
```

And call the method when we want to present the alert:
```Swift
func someMethod() {
	presentAlert(title: "Title", subtitle: "Subtitle", buttonTitle: "primary", secondaryButtonTitle: "secondary", showClose: true, iconType: .info)
        .observe(on: UIScheduler())
        .startWithValues { event in
            switch event.userAction {
            case .primaryButtonTapped: primaryAction()
            case .dismissButtonTapped: fallthrough
            case .secondaryButtonTapped: secondaryAction()
            }
            event.dismissAlert(animated: true)
		}	
}
```
