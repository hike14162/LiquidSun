import Foundation
import UIKit
import CoreLocation

open class lsHelper {
    
    open class func DateToTimeString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: date)
    }

    open class func DateToDateTimeString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy h:mma"
        return formatter.string(from: date)
    }
    
    open class func GetDateSuffex(day: Int)->String {
        if ((day == 1) || (day == 21) || (day == 31)) {
            return "st"
        } else if ((day == 2) || (day == 22)) {
            return "nd"
        } else if ((day == 3) || (day == 23)) {
            return "rd"
        } else {
            return "th"
        }
    }
    
    open class func DateToYearString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearStg = formatter.string(from: date)
        
        return "\(yearStg)"
    }
    
    open class func DateToDayString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dowStg = formatter.string(from: date)
        
        formatter.dateFormat = "dd"
        let domStg = formatter.string(from: date)
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: date)
        
        return "\(dowStg) the \(domStg)\(GetDateSuffex(day: components.day!))"
    }
    
    open class func DateByAddingDays(daysToAdd: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: daysToAdd, to: Date())
        return date!
    }
    
    open class func DateByAddingYears(daysToAdd: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .year, value: daysToAdd, to: Date())
        return date!
    }
    
    open class func darkBlueColor() -> UIColor {
        return UIColor(red: 0.1176, green: 0.1176, blue: 1, alpha: 1)
    }
    
    open class func lightBlueColor() -> UIColor {
        return UIColor(red: 0.3254, green: 0.7019, blue: 0.8554, alpha: 1)
    }
    
    open class func redColor() -> UIColor {
        return UIColor(red: 0.9333, green: 0.5647, blue: 0.5742, alpha: 1)
    }

    open class func getTitleBarAttributes() -> NSDictionary {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.clear        
        return NSDictionary(objects: [UIColor.white, shadow, UIFont(name: "Apple SD Gothic Neo", size: 20.0)!], forKeys: [NSAttributedStringKey.foregroundColor  as NSCopying, NSAttributedStringKey.shadow as NSCopying, NSAttributedStringKey.font as NSCopying])
    }

    open class func doubleToString(_ num: Double, decimalPlaces: Int) -> String {
        var numFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = decimalPlaces
            formatter.maximumFractionDigits = decimalPlaces
            formatter.numberStyle = .none
            return formatter
        }
        return numFormatter.string(from: NSNumber(value: num))!
    }
    
    open class func showAlertMessage(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }

    open class func getGUID() -> String {
        return UUID().uuidString
    }

}
