import Foundation

class lsWeather: NSObject {
// MARK: - Member Variables
    var delegate: lsWeatherDelegate?
    var webSvcs: lsRESTServices = lsRESTServices()
    var data: lsModel = lsModel()
    var longitude = ""
    var latitude = ""
    var id = ""
    let historyDays = 5
    
    var totalPastTemp = 0.0
    var averages = lsTrend()
    
// MARK: - Overrides
    override init() {
        super.init()
    }
    
// MARK: - Methods
    func getWeather(longitude: String, latitude: String) {
        getWeather(longitude: longitude, latitude: latitude,id: "")
    }
    
    func addWeatherResult(weatherDay: lsWeatherReport, isForecast: Bool) {
        if !isForecast {
            totalPastTemp += weatherDay.temperature
            averages.addWeatherPoint(temp: weatherDay.temperature, humidity: weatherDay.humidity, feelsLike: weatherDay.apparentTemperature)
        }
        
        self.data.addWeatherDay(weather: weatherDay)
        if (self.data.weatherDays.count == (self.historyDays + 1)) {
            if let dlgt = self.delegate {
                dlgt.weatherRetrieved(id: id, weatherDays: self.data.weatherDays, averages: averages)
                self.totalPastTemp = 0
                averages = lsTrend()
            }
        }
    }
    
    func getWeatherHistory(longitude: String, latitude: String, daysToAdd: Int) {
        webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: daysToAdd)) { (weatherDay, error) in
            if let wDay = weatherDay {
                self.addWeatherResult(weatherDay: wDay, isForecast: false)
            } else if let err = error {
                print(err.localizedDescription)
            }
        }

    }
    
    func getWeather(longitude: String, latitude: String, id: String) {
        self.id = id
        
        data.weatherDays = []
        self.longitude = longitude
        self.latitude = latitude
        
        if (reachabilityStatus != 0) {
            // get current weather
            webSvcs.getWeatherCurrentForecast(longitude: longitude, latitude: latitude) { (weatherDay, error) in
                if let wDay = weatherDay {
                    self.addWeatherResult(weatherDay: wDay, isForecast: true)
                } else if let err = error {
                    print(err.localizedDescription)
                }
            }
            getWeatherHistory(longitude: longitude, latitude: latitude, daysToAdd: -1)
            getWeatherHistory(longitude: longitude, latitude: latitude, daysToAdd: -2)
            getWeatherHistory(longitude: longitude, latitude: latitude, daysToAdd: -3)
            getWeatherHistory(longitude: longitude, latitude: latitude, daysToAdd: -4)
            getWeatherHistory(longitude: longitude, latitude: latitude, daysToAdd: -5)
        } else {
            if let dlgt = delegate {
                dlgt.networkNotReachable()
            }
            
            // retry timer
            let nwTimer = Timer(timeInterval: 1.0, target: self, selector:#selector(self.onNetworkRetryTick(_:)), userInfo: nil, repeats: true)
            RunLoop.main.add(nwTimer, forMode: RunLoop.Mode.default)
        }

    }
    
    @objc func onNetworkRetryTick(_ timer: Timer) {
        if (reachabilityStatus != 0) {
            timer.invalidate()
            if let dlgt = delegate {
                dlgt.networkReachable()
            }
            getWeather(longitude: longitude, latitude: latitude, id: id)
        }
    }
}
