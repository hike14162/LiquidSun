import UIKit
import StoreKit
import CoreLocation

public class Sunshine: UIViewController {
    
// MARK: - View Outlets
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var trendTable: UITableView!
    @IBOutlet weak var forecastView: UICollectionView!
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentGustLabel: UILabel!
    @IBOutlet weak var currentWindLabel: UILabel!
    @IBOutlet weak var currentSummaryLabel: UILabel!
    @IBOutlet weak var currentFeelsLikeLabel: UILabel!
    @IBOutlet weak var currentHighTempLabel: UILabel!
    @IBOutlet weak var currentHighTimeLabel: UILabel!
    @IBOutlet weak var currentLowTempLabel: UILabel!
    @IBOutlet weak var currentLowTimeLabel: UILabel!
    @IBOutlet weak var currentCompassImage: UIImageView!
    @IBOutlet weak var currentPercipLabel: UILabel!
    @IBOutlet weak var currentDewPointLabel: UILabel!
    @IBOutlet weak var currentVisibilityLabel: UILabel!
    @IBOutlet weak var currentCloudCoverLabel: UILabel!
    @IBOutlet weak var currentSunriseLabel: UILabel!
    @IBOutlet weak var currentSunsetCoverLabel: UILabel!
    @IBOutlet weak var windLeadingEdge: NSLayoutConstraint!
    @IBOutlet weak var dewPointLeadingEdge: NSLayoutConstraint!
    @IBOutlet weak var visibilityLeadingEdge: NSLayoutConstraint!
    @IBOutlet weak var locationButton: lsLocationButton!
    @IBOutlet weak var searchButton: lsSearchButton!
    
    // MARK: - View Actions
    @IBAction func gotoCurrentTap(_ sender: Any) {
    }
    
    @IBAction func creditTap(_ sender: Any) {
        if let url = URL(string: "https://darksky.net/poweredby/") {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    // MARK: - private member variables
    private var lsData = lsModel.sharedInstance
    private var watchSession: lsWatchSession?
    private var currentLocation: lsLocation?
    private var weatherInfo: lsWeather?
    
    // MARK: - private constants
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "entriesCount"
    
    // MARK: -  Overrides from UIViewController
    override public func viewDidLoad() {
        super.viewDidLoad()

        locationButton.delegate = self
        searchButton.delegate = self
        
        currentLocation = lsLocation()
        currentLocation?.delegate = self

        watchSession = lsWatchSession()
        watchSession?.delegate = self

        weatherInfo = lsWeather()
        weatherInfo?.delegate = self
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        loadingView.isHidden = false

        navigationController?.navigationBar.titleTextAttributes = (lsiOSHelper.getTitleBarAttributes(light: false) as? [NSAttributedString.Key : Any])

        NotificationCenter.default.addObserver(self, selector: #selector(self.foregroundEntered(_:)), name: NSNotification.Name(rawValue: "foregroundEntered"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustSEConstraints), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        currentLocation?.startLocation()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        resetScreen()
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchSegue" {
            guard
                let destNav = segue.destination as? UINavigationController,
                let destCont = destNav.viewControllers[0] as? lsSearchResultsView
                else {
                    return
            }
            destCont.delegate = self
        }
    }

    // MARK: -  Notification Handlers
    @objc func foregroundEntered(_ notification: Notification) {
        reAquireWeather()
    }
    
    @objc func adjustSEConstraints() {
        // code to account for SE width
        if UIScreen.main.nativeBounds.width < 700 {
            windLeadingEdge.constant = 55
            dewPointLeadingEdge.constant = 55
            visibilityLeadingEdge.constant = 50
        }
        trendTable.reloadData()
        forecastView.reloadData()
    }

    // MARK: -  view manipulation methods methods
    private func checkForReview() {
        var currentCount = userDefaults.integer(forKey: entriesKey)
        if currentCount > 10 {
            currentCount = 0
            userDefaults.set(currentCount, forKey: entriesKey)
            let callDelayTimer = Timer(timeInterval: 8.0, target: self, selector:#selector(self.onDelayTick(_:)), userInfo: nil, repeats: false)
            RunLoop.main.add(callDelayTimer, forMode: RunLoop.Mode.default)
        }
        userDefaults.set(currentCount + 1, forKey: entriesKey)
    }
    
    @objc func onDelayTick(_ timer: Timer) {
        timer.invalidate()
        SKStoreReviewController.requestReview()
    }
    
    private func reAquireWeather() {
        if (lsData.inSearchMode){
            resetScreen()
            self.title = "\(lsData.city), \(lsData.state)"
            self.loadLabel.text = "Retrieving weather data for \(lsData.city), \(lsData.state)"
            if let wInfo = weatherInfo {
                wInfo.getWeather(longitude: lsData.longitude, latitude: lsData.latitude)
            }
        } else {
            resetScreen()
            currentLocation?.startLocation()
        }
    }
    
    private func resetScreen() {
        lsData.weatherDays = []
        lsData.backgroundWeatherDays = []
        
        loadingIndicator.startAnimating()
        loadingView.isHidden = false

        iconImage.image = UIImage(named: "clear-day")
        currentCompassImage.image = UIImage(named: "cp N")
        currentTempLabel.text = "N/A"
        currentFeelsLikeLabel.text = "N/A"
        currentHumidityLabel.text = "N/A"
        currentWindLabel.text = "N/A"
        currentGustLabel.text = "N/A"
        currentSummaryLabel.text = "Loading..."
        currentHighTempLabel.text = "N/A"
        currentHighTimeLabel.text = "N/A"
        currentLowTempLabel.text = "N/A"
        currentLowTimeLabel.text = "N/A"
        currentVisibilityLabel.text = "N/A"
        currentDewPointLabel.text = "N/A"
        currentPercipLabel.text = "N/A"
        currentCloudCoverLabel.text = "N/A"
        currentSunsetCoverLabel.text = "N/A"
        currentSunriseLabel.text = "N/A"
        
        adjustSEConstraints()
    }
    
    private func populateScreen() {
        if let ws = watchSession {
            ws.pushLocationText(location: "\(lsData.city), \(lsData.state)")
            ws.pushDataToWatch(data: lsData)
        }

        loadingIndicator.stopAnimating()
        loadingView.isHidden = true
        
        iconImage.image = UIImage(named: lsData.weatherDays[0].icon)
        var windDir = "N"
        
        if ((lsData.weatherDays[0].windBearing > 337.5) || (lsData.weatherDays[0].windBearing <= 22.5)) {
            windDir = "S"
        } else if((lsData.weatherDays[0].windBearing > 22.5) && (lsData.weatherDays[0].windBearing <= 67.5)) {
            windDir = "SW"
        } else if((lsData.weatherDays[0].windBearing > 67.5) && (lsData.weatherDays[0].windBearing <= 112.5)) {
            windDir = "W"
        } else if((lsData.weatherDays[0].windBearing > 112.5) && (lsData.weatherDays[0].windBearing <= 157.5)) {
            windDir = "NW"
        } else if((lsData.weatherDays[0].windBearing > 157.5) && (lsData.weatherDays[0].windBearing <= 202.5)) {
            windDir = "N"
        } else if((lsData.weatherDays[0].windBearing > 202.5) && (lsData.weatherDays[0].windBearing <= 247.5)) {
            windDir = "NE"
        } else if((lsData.weatherDays[0].windBearing > 247.5) && (lsData.weatherDays[0].windBearing <= 292.5)) {
            windDir = "E"
        } else if((lsData.weatherDays[0].windBearing > 292.5) && (lsData.weatherDays[0].windBearing <= 337.5)) {
            windDir = "SE"
        }
        
        currentTempLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].temperature,decimalPlaces: 1))\u{00B0}"
        currentFeelsLikeLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].apparentTemperature,decimalPlaces: 1))\u{00B0}"
        currentHumidityLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].humidity*100,decimalPlaces: 1))%"
        currentWindLabel.text = "\(windDir) \(lsHelper.doubleToString(lsData.weatherDays[0].windSpeed,decimalPlaces: 1)) mph"
        currentGustLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].windGust,decimalPlaces: 1)) mph"
        currentSummaryLabel.text = lsData.weatherDays[0].summary
        currentHighTempLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].temperatureHigh,decimalPlaces: 1))\u{00B0}"
        currentHighTimeLabel.text = lsHelper.DateToTimeString(lsData.weatherDays[0].temperatureHighTime)
        currentLowTempLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].temperatureLow,decimalPlaces: 1))\u{00B0}"
        currentLowTimeLabel.text = lsHelper.DateToTimeString(lsData.weatherDays[0].temperatureLowTime)
        currentVisibilityLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].visibility,decimalPlaces: 1)) mi"
        currentDewPointLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].dewPoint,decimalPlaces: 1))\u{00B0}"
        currentPercipLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].precipProbability*100,decimalPlaces: 1))%"
        currentCloudCoverLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].cloudCover*100,decimalPlaces: 1))%"
        currentSunsetCoverLabel.text = "\(lsHelper.DateToTimeString(lsData.weatherDays[0].sunsetTime))"
        currentSunriseLabel.text = "\(lsHelper.DateToTimeString(lsData.weatherDays[0].sunriseTime))"
        
        adjustSEConstraints()
        
        checkForReview()
    }
}

// MARK: -  lsSearchDelegate implementation
extension Sunshine: lsSearchDelegate {
    func searchLocationSelected(longitude: String, latitude: String, city: String, state: String) {
        lsData.longitude = longitude
        lsData.latitude = latitude
        lsData.city = city
        lsData.state = state
                
        let loc = CLLocation(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
        CLGeocoder().reverseGeocodeLocation(loc) { (placemarks, error) in
            if let pmks = placemarks {
                let pm = pmks[0] as CLPlacemark
                if let tz = pm.timeZone {
                    let localGMT = TimeZone.current.secondsFromGMT() / 3600
                    let searchGMT = (tz.secondsFromGMT()/3600)
                    self.lsData.GMTOffsetSeconds = (localGMT - searchGMT) * 3600 * -1
                    
                    if let wInfo = self.weatherInfo {
                        wInfo.getWeather(longitude: longitude, latitude: latitude)
                        self.title = "\(city), \(state)"
                        self.loadLabel.text = "Retrieving weather data for \(city), \(state)"
                    }
                }
            }
        }
    }
}

// MARK: - lsWatchDelegate
extension Sunshine: lsWatchDelegate {
    func getDataForWatch() {
    }
    
}

// MARK: - lsLocationDelegate
extension Sunshine: lsLocationDelegate {
    func locationDenied(id: String) {
        loadingView.isHidden = false
        loadLabel.text = "Unable to access your location.  Please enable location services in Settings."
        loadingIndicator.isHidden = true
    }
    
    func locationAuthorized(id: String) {
        loadLabel.text = "Retrieving weather data"
        loadingIndicator.isHidden = false
    }
    
    func locationFound(id: String, longitude: String, latitude: String) {
        lsData.longitude = longitude
        lsData.latitude = latitude
        if let wInfo = weatherInfo {
            wInfo.getWeather(longitude: longitude, latitude: latitude)
        }
        
    }
    
    func locationString(id: String, city: String, state: String) {
        lsData.city = city
        lsData.state = state
        title = "\(city), \(state)"
        loadLabel.text = "Retrieving weather data for \(city), \(state)"
    }
}

// MARK: - lsWeatherDelegate
extension Sunshine: lsWeatherDelegate {
    func networkNotReachable() {
        loadLabel.text = "Searching for a network connection..."
    }
    
    func networkReachable() {
        
    }
    
    func weatherRetrieved(id: String, weatherDays: [lsWeatherReport]) {
        lsData.weatherDays = weatherDays
        populateScreen()
    }

}

extension Sunshine: lsLocationButtonDelegate, lsSearchButtonDelegate {
    func searchRequested(_sender: Any) {
        performSegue(withIdentifier: "searchSegue", sender: self)
    }
    
    func locationRequested(_sender: Any) {
        lsData.inSearchMode = false
        reAquireWeather()
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
