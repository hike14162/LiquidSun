import Foundation
import UIKit

public class lsHelper {
    // MARK: - Date Methods
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
    
    public class func DateToGMTString(_ date: Date)-> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ZZZZ"
        let yearStg = formatter.string(from: date)
        
        return "\(yearStg)"
    }

    public class func DateToDOWString(_ date: Date)-> String {
        let cal = Calendar(identifier: .gregorian)
        let weekDay = cal.component(.weekday, from: date)

        var dow = ""
        switch weekDay {
        case 1:
            dow = "Sun"
        case 2:
            dow = "Mon"
        case 3:
            dow = "Tue"
        case 4:
            dow = "Wed"
        case 5:
            dow = "Thr"
        case 6:
            dow = "Fri"
        case 7:
            dow = "Sat"
        default:
            dow = ""
        }
//        print("\(DateToDateTimeString(date)) ")        
        return "\(dow) "
    }
    
    public class func DateToDOMString(_ date: Date)-> String {
        let cal = Calendar(identifier: .gregorian)
        let mDay = cal.component(.day, from: date)
        
        return "\(mDay)"
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
    
    // MARK: - Color Methods
    public class func darkBlueColor() -> UIColor {
        return UIColor(red: 0.1176, green: 0.1176, blue: 1, alpha: 1)
    }
    
    public class func lightBlueColor() -> UIColor {
        return UIColor(red: 0.3254, green: 0.7019, blue: 0.8554, alpha: 1)
    }
    
    public class func redColor() -> UIColor {
        return UIColor(red: 0.9333, green: 0.5647, blue: 0.5742, alpha: 1)
    }
    
    
    // MARK: - Misc utility methods
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

    public class func DoubleToWholeString(value: Double)->String {
        return "\(Int(value))"
    }
}
