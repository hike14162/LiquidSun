import Foundation
import UIKit

open class lsiOSHelper {
    // MARK: - Misc iOS util methods
    open class func isiPad() -> Bool
    {
        return (UIDevice.current.userInterfaceIdiom == .pad)
    }

    open class func getTitleBarAttributes(light: Bool) -> NSDictionary {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.clear
        var foreColor = UIColor.white
        
        if (light) {
            foreColor = lsHelper.darkBlueColor()
        }
        return NSDictionary(objects: [foreColor, shadow, UIFont(name: "Apple SD Gothic Neo", size: 20.0)!], forKeys: [NSAttributedString.Key.foregroundColor as NSCopying, NSAttributedString.Key.shadow as NSCopying, NSAttributedString.Key.font as NSCopying])
    }
    
    open class func showAlertMessage(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
