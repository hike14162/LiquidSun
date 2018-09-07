import Foundation
import MapKit

private let _ModelSingletonSharedInstance = lsModel()
open class lsModel {
    open class var sharedInstance : lsModel {
        return _ModelSingletonSharedInstance
    }

    var hMode: HistoryMode = .years
    
    var city: String = ""
    var state: String = ""
    var longitude: String = ""
    var latitude: String = ""
    var datetime: String = ""
    var searchItems: [MKLocalSearchCompletion] = []

    var inSearchMode: Bool = false
    
    func setID() -> String  {
        let id = lsHelper.getGUID()
        UserDefaults.standard.set(id, forKey: "instID")
        return id
    }
    
    func getID() -> String {
        let id = UserDefaults.standard.object(forKey: "instID") as? String ?? setID()
        return id
    }
    
    var weatherDays: [lsWeatherReport] = []
    func addWeatherDay(weather: lsWeatherReport) {
        weatherDays.append(weather)
        let sortedArray = weatherDays.sorted(by: {
            (evt1: lsWeatherReport, evt2: lsWeatherReport) -> Bool in
            return evt1.time > evt2.time
        })
        weatherDays = sortedArray
    }
}
