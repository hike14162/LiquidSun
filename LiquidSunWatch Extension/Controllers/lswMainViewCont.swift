import WatchKit
import Foundation

class lswMainViewCont: WKInterfaceController, lswWeatherDelegate, lsLocationDelegate {
    @IBOutlet weak var currentTable: WKInterfaceTable!
    @IBOutlet weak var pastTable: WKInterfaceTable!
    @IBOutlet weak var weatherGroup: WKInterfaceGroup!
    @IBOutlet weak var progressButton: WKInterfaceButton!
    @IBOutlet weak var loadingSpinAnim: WKInterfaceGroup!
    @IBOutlet var iPhoneMessage: WKInterfaceGroup!
    
    @IBAction func retryTap() {
        iPhoneFetch.beginTransfer()
//        nativeFetch.beginTransfer()
    }
    
    var lsData = lsModel.sharedInstance
    var iPhoneFetch = lswiPhoneFetch()
//    var nativeFetch = lswNativeFetch()

    var retryOk = false
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        iPhoneFetch.delegate = self
//        nativeFetch.delegate = self
    }
    
    override func willActivate() {
        super.willActivate()

        startWait()
        iPhoneFetch.beginTransfer()
//        nativeFetch.beginTransfer()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    override func didAppear() {
    }

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
        let row = currentTable.rowController(at: 0) as! lswCurrentCell
        row.lblCurrentCityState.setText(lsData.weatherLocationString)

        row.lblCurrentTemp.setText("\(lsHelper.doubleToString(lsData.weatherDays[0].temperature,decimalPlaces: 1))\u{00B0}")
        row.lblCurrentFeels.setText("Feels \(lsHelper.doubleToString(lsData.weatherDays[0].apparentTemperature,decimalPlaces: 1))\u{00B0}")
        
        row.lblCurrentWind.setText("\(lsHelper.doubleToString(lsData.weatherDays[0].windSpeed,decimalPlaces: 1)) mph - \(windDir(direction: lsData.weatherDays[0].windBearing))")
        
        row.lblCurrentGust.setText("Gusts \(lsHelper.doubleToString(lsData.weatherDays[0].windGust,decimalPlaces: 1)) mph")

        if (lsData.weatherDays[0].icon == "clear-day") {
            row.imgCurrent.setImage(UIImage(named: "sunny"))
        }
        else if (lsData.weatherDays[0].icon == "clear-night") {
            row.imgCurrent.setImage(UIImage(named: "clear-night"))
        }
        else if (lsData.weatherDays[0].icon == "partly-cloudy-day") {
            row.imgCurrent.setImage(UIImage(named: "partly-cloudy-day"))
        }
        else if (lsData.weatherDays[0].icon == "partly-cloudy-night") {
            row.imgCurrent.setImage(UIImage(named: "partly-cloudy-night"))
        }
        else if (lsData.weatherDays[0].icon == "cloudy") {
            row.imgCurrent.setImage(UIImage(named: "cloudy"))
        }
        else if (lsData.weatherDays[0].icon == "rain") {
            row.imgCurrent.setImage(UIImage(named: "rain"))
        }
        else if (lsData.weatherDays[0].icon == "sleet") {
            row.imgCurrent.setImage(UIImage(named: "sleet"))
        }
        else if (lsData.weatherDays[0].icon == "snow") {
            row.imgCurrent.setImage(UIImage(named: "snow"))
        }
        else if (lsData.weatherDays[0].icon == "wind") {
            row.imgCurrent.setImage(UIImage(named: "wind"))
        }
        else if (lsData.weatherDays[0].icon == "fog") {
            row.imgCurrent.setImage(UIImage(named: "fog"))
        }
        else {
            row.imgCurrent.setImage(UIImage(named: "sunny"))
        }
        
        pastTable.setNumberOfRows(lsData.weatherDays.count-1, withRowType: "lswPastCell")
        for index in 1..<lsData.weatherDays.count {
            let prow = pastTable.rowController(at: index-1) as! lswPastCell
            prow.lblPastYear.setText("\(lsHelper.DateToYearString(lsData.weatherDays[index].time))")
            prow.lblPastTemp.setText("\(lsHelper.doubleToString(lsData.weatherDays[index].temperature,decimalPlaces: 1))\u{00B0}")
            
            if (lsData.weatherDays[index].icon == "clear-day") {
                prow.imgPastConditions.setImage(UIImage(named: "sunny"))
            }
            else if (lsData.weatherDays[index].icon == "clear-night") {
                prow.imgPastConditions.setImage(UIImage(named: "clear-night"))
            }
            else if (lsData.weatherDays[index].icon == "partly-cloudy-day") {
                prow.imgPastConditions.setImage(UIImage(named: "partly-cloudy-day"))
            }
            else if (lsData.weatherDays[index].icon == "partly-cloudy-night") {
                prow.imgPastConditions.setImage(UIImage(named: "partly-cloudy-night"))
            }
            else if (lsData.weatherDays[index].icon == "cloudy") {
                prow.imgPastConditions.setImage(UIImage(named: "cloudy"))
            }
            else if (lsData.weatherDays[index].icon == "rain") {
                prow.imgPastConditions.setImage(UIImage(named: "rain"))
            }
            else if (lsData.weatherDays[index].icon == "sleet") {
                prow.imgPastConditions.setImage(UIImage(named: "sleet"))
            }
            else if (lsData.weatherDays[index].icon == "snow") {
                prow.imgPastConditions.setImage(UIImage(named: "snow"))
            }
            else if (lsData.weatherDays[index].icon == "wind") {
                prow.imgPastConditions.setImage(UIImage(named: "wind"))
            }
            else if (lsData.weatherDays[index].icon == "fog") {
                prow.imgPastConditions.setImage(UIImage(named: "fog"))
            }
            else {
                prow.imgPastConditions.setImage(UIImage(named: "sunny"))
            }
            
            
            if (lsData.weatherDays[index].temperature < lsData.weatherDays[0].temperature) {
                prow.lblPastTemp.setTextColor(lsHelper.lightBlueColor())
            } else if (lsData.weatherDays[index].temperature > lsData.weatherDays[0].temperature) {
                prow.lblPastTemp.setTextColor(lsHelper.redColor())
            } else if (lsData.weatherDays[index].temperature == lsData.weatherDays[0].temperature) {
                prow.lblPastTemp.setTextColor(.white)
            }
            
            
        }
        stopWait()
    }

    func weatherDataReceived(weatherData: [Data]) {
        updateWeatherData(weatherArr: weatherData)
    }

    func updateCityStateLabel(locationString: String) {
        lsData.weatherLocationString = locationString
    }
    
    func iPhoneNotReachable() {
        iPhoneMessage.setHidden(false)
    }
    
    func iPhoneReachable() {
        iPhoneMessage.setHidden(true)
    }

    // lsLocationDelegate implementation
    func locationDenied(id: String) {
        
    }
    
    func locationAuthorized(id: String) {
        
    }
    
    func locationFound(id: String, longitude: String, latitude: String) {
        print("\(longitude)  \(latitude)")
    }
    
    func locationString(id: String, city: String, state: String) {
        print("\(city), \(state)")
    }
}
