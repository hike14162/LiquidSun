import Foundation

class lsWeather: NSObject {
    
    var delegate: lsWeatherDelegate?
    var webSvcs: lsRESTServices = lsRESTServices()
    var data: lsModel = lsModel()
    
    var longitude = ""
    var latitude = ""
    var id = ""
    
    override init() {
        super.init()
        webSvcs.delegate = self
    }
    
    func getWeather(longitude: String, latitude: String) {
        getWeather(longitude: longitude, latitude: latitude,id: "")
    }
    
    func getWeather(longitude: String, latitude: String, id: String) {
        self.id = id
        
        data.weatherDays = []
        self.longitude = longitude
        self.latitude = latitude
        
        if (reachabilityStatus != 0) {
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: 0))
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -1))
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -2))
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -3))
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -4))
            webSvcs.getWeatherHistory(longitude: longitude, latitude: latitude, date: lsHelper.DateByAddingYears(daysToAdd: -5))
        } else {
            if let dlgt = delegate {
                dlgt.networkNotReachable()
            }
            
            // retry timer
            let nwTimer = Timer(timeInterval: 1.0, target: self, selector:#selector(self.onNetworkRetryTick(_:)), userInfo: nil, repeats: true)
            RunLoop.main.add(nwTimer, forMode: RunLoopMode.defaultRunLoopMode)
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

extension lsWeather: lsRESTServicesDelegate {
    func weatherDayReturned(weatherDay: lsWeatherReport) {
        data.addWeatherDay(weather: weatherDay)
        if data.weatherDays.count == 6 {
            if let dlgt = delegate {
                dlgt.weatherRetrieved(id: id, weatherDays: data.weatherDays)
            }
        }
    }
}
