import Foundation
import UIKit

public class lsHelper {
    public class func DateToTimeString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: date)
    }

    public class func DateToDateTimeString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy h:mma"
        return formatter.string(from: date)
    }
    
    public class func GetDateSuffex(day: Int)->String {
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
    
    public class func DateToYearString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let yearStg = formatter.string(from: date)
        
        return "\(yearStg)"
    }
    
    public class func DateToDayString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let dowStg = formatter.string(from: date)
        
        formatter.dateFormat = "dd"
        let domStg = formatter.string(from: date)
        
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.day], from: date)
        
        return "\(dowStg) the \(domStg)\(GetDateSuffex(day: components.day!))"
    }
    
    public class func DateByAddingDays(daysToAdd: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: daysToAdd, to: Date())
        return date!
    }
    
    public class func DateByAddingYears(daysToAdd: Int) -> Date {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .year, value: daysToAdd, to: Date())
        return date!
    }
    
    public class func darkBlueColor() -> UIColor {
        return UIColor(red: 0.1176, green: 0.1176, blue: 1, alpha: 1)
    }
    
    public class func lightBlueColor() -> UIColor {
        return UIColor(red: 0.3254, green: 0.7019, blue: 0.8554, alpha: 1)
    }
    
    public class func redColor() -> UIColor {
        return UIColor(red: 0.9333, green: 0.5647, blue: 0.5742, alpha: 1)
    }

    public class func doubleToString(_ num: Double, decimalPlaces: Int) -> String {
        var numFormatter: NumberFormatter {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = decimalPlaces
            formatter.maximumFractionDigits = decimalPlaces
            formatter.numberStyle = .none
            return formatter
        }
        return numFormatter.string(from: NSNumber(value: num))!
    }
    
    public class func getGUID() -> String {
        return UUID().uuidString
    }

}
