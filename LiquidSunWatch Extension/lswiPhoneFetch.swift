import Foundation
import WatchConnectivity

class lswiPhoneFetch: NSObject, WCSessionDelegate {
    
    var delegate: lswWeatherDelegate! = nil
    var session: WCSession?
    var activated = false
    
    override init() {
        super .init()
        
        activated = false
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    public func beginTransfer() {
        if (activated) {
            requestDataFromiPhone()
        } else {
            if let ssn = session {
                ssn.activate()
            }
        }
    }
    
    func requestDataFromiPhone() {
        if let ssn = session {
            if (ssn.isReachable) {
                delegate.iPhoneReachable()
                ssn.sendMessage(["dataRequest": "getWeather"],
                                replyHandler:{ (response) -> Void in                                    
                                    if let weatherDataArr = response["getWeatherResultData"] as? [Data] {
                                        if (weatherDataArr.count > 0) {
                                            DispatchQueue.main.async {
                                                self.delegate.weatherDataReceived(weatherData: weatherDataArr)
                                            }
                                        }
                                    }
                                    
                                    if let tripData = response["getWeatherResult"] as? String {
                                        print("wait \(tripData)")
                                    }
                                    
                }, errorHandler:
                    {
                        (error) -> Void in
                        
                }
                )
            } else {
                // start timer to check reachability on 1.5 seconds
                let nwTimer = Timer(timeInterval: 1.5, target: self, selector:#selector(self.onReachabilityDelayTick(_:)), userInfo: nil, repeats: true)
                RunLoop.main.add(nwTimer, forMode: RunLoop.Mode.default)
                
            }
        } else { // could not unwrap
            
        }        
    }

    @objc func onReachabilityDelayTick(_ timer: Timer) {
        timer.invalidate()
        if let ssn = session {
            if (!ssn.isReachable) {
                delegate.iPhoneNotReachable()
            }
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if (activationState == .activated) {
            self.session = session
            activated = true
            requestDataFromiPhone()
        } else {
            print(error.debugDescription)
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        if let weatherDataArr = message["getWeatherResultData"] as? [Data] {
            if (weatherDataArr.count > 0) {
                DispatchQueue.main.async {
                    self.delegate.weatherDataReceived(weatherData: weatherDataArr)
                }
                replyHandler(["watchReceive": "\(weatherDataArr.count)"])
            }
        } else {
            replyHandler(["watchReceive": "0"])
        }
        
        if let locationStg = message["pushLocation"] as? String {
            delegate.updateCityStateLabel(locationString: locationStg)
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        
    }
    
}
