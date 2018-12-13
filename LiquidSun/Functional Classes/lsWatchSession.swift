import Foundation
import WatchConnectivity

final class lsWatchSession: NSObject {
    // MARK: - member variables
    var lsData = lsModel.sharedInstance
    var lsSearch = lsSearchState.sharedInstance
    var session: WCSession?
    var activated = false
    var delegate: lsWatchDelegate? = nil
    var currentLocation: lsLocation? = nil
    var weatherInfo: lsWeather? = nil
    var data: lsModel = lsModel()
    
    // MARK: - Overrides
    override init() {
        super .init()
        currentLocation = lsLocation()
        currentLocation?.delegate = self
        
        weatherInfo = lsWeather()
        weatherInfo?.delegate = self
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }

    }
    
    // MARK: - Methods
    func pushLocationText(location: String) {
        if activated {
            if let ssn = session {
                if ssn.isReachable {
                    ssn.sendMessage(["pushLocation": location],
                                    replyHandler: { (response) -> Void in
                    }
                        , errorHandler: {(error) -> Void in
                            print("ERROR \(error.localizedDescription)")
                    })
                }
            }
        }

    }
    
    func pushDataToWatch(data: lsModel) {
        var jsonDataArr: [Data] = []
        if activated {
            if let ssn = session {
                if ssn.isReachable {
                    for wd in data.backgroundWeatherDays {
                        jsonDataArr.append(wd.data)
                    }
                    ssn.sendMessage(["getWeatherResultData": jsonDataArr],
                                    replyHandler: { (response) -> Void in
                    }
                        , errorHandler: {(error) -> Void in
                            print("ERROR \(error.localizedDescription)")
                    })
                }
            }
        }
    }

}

// MARK: - WCSessionDelegate implementation
extension lsWatchSession: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if (activationState == .activated) {
            activated = true
            self.session = session
        } else {
            print(error.debugDescription)
        }
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let reference = message["dataRequest"] as? String {
            if (reference == "getWeather") {
                currentLocation?.startLocation()
                replyHandler(["getWeatherResult": "fetching"])
            }
        }
    }
}

// MARK: - lsLocationDelegate implementation
extension lsWatchSession: lsLocationDelegate {
    func locationDenied(id: String) {
    }
    
    func locationAuthorized(id: String) {
    }
    
    func locationFound(id: String, longitude: String, latitude: String) {
        weatherInfo?.getWeather(longitude: longitude, latitude: latitude)
    }
    
    func locationString(id: String, city: String, state: String) {
        pushLocationText(location: "\(city), \(state)")
    }
}

// MARK: - lsWeatherDelegate implementation
extension lsWatchSession: lsWeatherDelegate {
    func networkNotReachable() {
    }
    
    func networkReachable() {
    }
    
    func weatherRetrieved(id: String, weatherDays: [lsWeatherReport]) {
        data.backgroundWeatherDays = weatherDays
        pushDataToWatch(data: data)
    }
}

