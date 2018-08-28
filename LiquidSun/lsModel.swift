import Foundation

private let _ModelSingletonSharedInstance = lsModel()
open class lsModel {
    open class var sharedInstance : lsModel {
        return _ModelSingletonSharedInstance
    }

    var hMode: HistoryMode = .years

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
