import Foundation

class lsWeather: NSObject {
// MARK: - Member Variables
    var delegate: lsWeatherDelegate?
    var webSvcs: lsRESTServices = lsRESTServices()
    var data: lsModel = lsModel()
    var longitude = ""
    var latitude = ""
    var id = ""
    
// MARK: - Overrides
    override init() {
        super.init()
    }
    
// MARK: - Methods
    func getWeather(longitude: String, latitude: String) {
        getWeather(longitude: longitude, latitude: latitude,id: "")
    }
    
    func addWeatherResult(weatherDay: lsWeatherReport) {
        self.data.addWeatherDay(weather: weatherDay)
        if self.data.weatherDays.count == 6 {
            if let dlgt = self.delegate {
                dlgt.weatherRetrieved(id: id, weatherDays: self.data.weatherDays)
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
                    self.addWeatherResult(weatherDay: wDay)
                } else if let err = error {
                    print(err.localizedDescription)
                }
            }
            
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -1)) { (weatherDay, error) in
                if let wDay = weatherDay {
                    self.addWeatherResult(weatherDay: wDay)
                } else if let err = error {
                    print(err.localizedDescription)
                }
            }
            
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -2)) { (weatherDay, error) in
                if let wDay = weatherDay {
                    self.addWeatherResult(weatherDay: wDay)
                } else if let err = error {
                    print(err.localizedDescription)
                }
            }
            
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -3)) { (weatherDay, error) in
                if let wDay = weatherDay {
                    self.addWeatherResult(weatherDay: wDay)
                } else if let err = error {
                    print(err.localizedDescription)
                }
            }
            
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -4)) { (weatherDay, error) in
                if let wDay = weatherDay {
                    self.addWeatherResult(weatherDay: wDay)
                } else if let err = error {
                    print(err.localizedDescription)
                }
            }
            
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -5)) { (weatherDay, error) in
                if let wDay = weatherDay {
                    self.addWeatherResult(weatherDay: wDay)
                } else if let err = error {
                    print(err.localizedDescription)
                }
            }

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
