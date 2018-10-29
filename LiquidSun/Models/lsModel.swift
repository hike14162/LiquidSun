import Foundation

private let _ModelSingletonSharedInstance = lsModel()
open class lsModel {
    open class var sharedInstance : lsModel {
        return _ModelSingletonSharedInstance
    }
    
    var city: String = ""
    var state: String = ""
    var longitude: String = ""
    var latitude: String = ""
    var datetime: String = ""
    var weatherLocationString = ""
    
    var weatherDays: [lsWeatherReport] = []
    var backgroundWeatherDays: [lsWeatherReport] = []
    
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
    
    func addBackgroundWeatherDay(weather: lsWeatherReport) {
        backgroundWeatherDays.append(weather)
        let sortedArray = backgroundWeatherDays.sorted(by: {
            (evt1: lsWeatherReport, evt2: lsWeatherReport) -> Bool in
            return evt1.time > evt2.time
        })
        backgroundWeatherDays = sortedArray
    }
    
    func addWeatherDay(weather: lsWeatherReport) {
        weatherDays.append(weather)
        let sortedArray = weatherDays.sorted(by: {
            (evt1: lsWeatherReport, evt2: lsWeatherReport) -> Bool in
            return evt1.time > evt2.time
        })
        weatherDays = sortedArray
        backgroundWeatherDays = sortedArray
    }
}
