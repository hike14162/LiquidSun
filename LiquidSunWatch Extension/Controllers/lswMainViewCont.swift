import WatchKit
import Foundation

class lswMainViewCont: WKInterfaceController  {
    // MARK: - View Outlets
    @IBOutlet weak var currentTable: WKInterfaceTable!
    @IBOutlet weak var pastTable: WKInterfaceTable!
    @IBOutlet weak var weatherGroup: WKInterfaceGroup!
    @IBOutlet weak var progressButton: WKInterfaceButton!
    @IBOutlet weak var loadingSpinAnim: WKInterfaceGroup!
    @IBOutlet var iPhoneMessage: WKInterfaceGroup!
    
    // MARK: - View Actions
    @IBAction func retryTap() {
        iPhoneFetch.beginTransfer()
    }
    
    // MARK: - Member variables
    var lsData = lsModel.sharedInstance
    var iPhoneFetch = lswiPhoneFetch()
    var retryOk = false
    var iPhoneIsReachable = true
    
    // MARK: - Overrides
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        iPhoneFetch.delegate = self
    }
    
    override func willActivate() {
        super.willActivate()

        startWait()
        iPhoneFetch.beginTransfer()
    }
    
    // MARK: - Public methods
    func startWait() {
        weatherGroup.setHidden(true)
        progressButton.setHidden(false)
        retryOk = true
        
        // retry timer after 8 seconds
        let phTimer = Timer(timeInterval: 8.0, target: self, selector:#selector(self.onPhoneRetryTick(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(phTimer, forMode: .default)
        
        
        //start animation
        let duration = 1.7
        let delay = DispatchTime.now() + Double(Int64((duration + 0.15) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        loadingSpinAnim.setBackgroundImageNamed("wWait")
        loadingSpinAnim.startAnimatingWithImages(in: NSRange(location: 0, length: 6), duration: duration, repeatCount: 0)
        DispatchQueue.main.asyncAfter(deadline: delay)
        { () -> Void in
            
        }
        
    }
    
    @objc func onPhoneRetryTick(_ timer: Timer) {
        if (retryOk) {
            iPhoneFetch.beginTransfer()
        } else {
            timer.invalidate()
        }
    }
    
    func stopWait() {
        retryOk = false
        progressButton.setHidden(true)
        weatherGroup.setHidden(false)
        loadingSpinAnim.stopAnimating()
    }

    func windDir(direction: Double)->String {
        var dirStg = ""
        if ((direction > 337.5) || (direction <= 22.5)) {
            dirStg = "S"
        } else if((direction > 22.5) && (direction <= 67.5)) {
            dirStg = "SW"
        } else if((direction > 67.5) && (direction <= 112.5)) {
            dirStg = "W"
        } else if((direction > 112.5) && (direction <= 157.5)) {
            dirStg = "NW"
        } else if((direction > 157.5) && (direction <= 202.5)) {
            dirStg = "N"
        } else if((direction > 202.5) && (direction <= 247.5)) {
            dirStg = "NE"
        } else if((direction > 247.5) && (direction <= 292.5)) {
            dirStg = "E"
        } else if((direction > 292.5) && (direction <= 337.5)) {
            dirStg = "SE"
        }
        
        return dirStg
    }
    
    func updateWeatherData(weatherArr: [Data]) {
        lsData.weatherDays = []
        for jsonData in weatherArr {
            lsData.weatherDays.append(lsWeatherReport(jsonData: jsonData))
        }
        
        currentTable.setNumberOfRows(1, withRowType: "lswCurrentCell")
        if let row = currentTable.rowController(at: 0) as? lswCurrentCell {
            row.lblCurrentCityState.setText(lsData.weatherLocationString)
            
            row.lblCurrentTemp.setText("\(lsHelper.doubleToString(lsData.weatherDays[0].temperature,decimalPlaces: 1))\u{00B0}")
            row.lblCurrentFeels.setText("Feels \(lsHelper.doubleToString(lsData.weatherDays[0].apparentTemperature,decimalPlaces: 1))\u{00B0}")            
            row.lblCurrentWind.setText("\(lsHelper.doubleToString(lsData.weatherDays[0].windSpeed,decimalPlaces: 1)) mph - \(windDir(direction: lsData.weatherDays[0].windBearing))")
            row.lblCurrentGust.setText("Gusts \(lsHelper.doubleToString(lsData.weatherDays[0].windGust,decimalPlaces: 1)) mph")
            row.imgCurrent.setImage(UIImage(named: lsData.weatherDays[0].icon))
        }
        
        pastTable.setNumberOfRows(lsData.weatherDays.count-1, withRowType: "lswPastCell")
        for index in 1..<lsData.weatherDays.count {
            if let prow = pastTable.rowController(at: index-1) as? lswPastCell {
                prow.lblPastYear.setText("\(lsHelper.DateToYearString(lsData.weatherDays[index].time))")
                prow.lblPastTemp.setText("\(lsHelper.doubleToString(lsData.weatherDays[index].temperature,decimalPlaces: 1))\u{00B0}")
                
                prow.imgPastConditions.setImage(UIImage(named: lsData.weatherDays[index].icon))
                
                if (lsData.weatherDays[index].temperature < lsData.weatherDays[0].temperature) {
                    prow.lblPastTemp.setTextColor(lsHelper.lightBlueColor())
                } else if (lsData.weatherDays[index].temperature > lsData.weatherDays[0].temperature) {
                    prow.lblPastTemp.setTextColor(lsHelper.redColor())
                } else if (lsData.weatherDays[index].temperature == lsData.weatherDays[0].temperature) {
                    prow.lblPastTemp.setTextColor(.white)
                }
            }
        }
        stopWait()
    }
}

// MARK: - lsLocationDelegate implementation
extension lswMainViewCont: lsLocationDelegate {
    func locationDenied(id: String) {
    }
    
    func locationAuthorized(id: String) {
    }
    
    func locationFound(id: String, longitude: String, latitude: String) {
    }
    
    func locationString(id: String, city: String, state: String) {
    }
}

// MARK: - lswWeatherDelegate implementation
extension lswMainViewCont: lswWeatherDelegate {
    func weatherDataReceived(weatherData: [Data]) {
        updateWeatherData(weatherArr: weatherData)
    }
    
    func updateCityStateLabel(locationString: String) {
        lsData.weatherLocationString = locationString
    }
    
    func iPhoneNotReachable() {
        iPhoneIsReachable = false
        let warnDelayTimer = Timer(timeInterval: 2.0, target: self, selector:#selector(self.onDelayTick(_:)), userInfo: nil, repeats: false)
        RunLoop.main.add(warnDelayTimer, forMode: .default)
    }
    
    @objc func onDelayTick(_ timer: Timer) {
        if !iPhoneIsReachable {
            iPhoneMessage.setHidden(false)
        }
    }
    
    func iPhoneReachable() {
        iPhoneIsReachable = true
        iPhoneMessage.setHidden(true)
    }
}
