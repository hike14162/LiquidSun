import UIKit
import os.log

class Sunshine: UIViewController, lsSearchDelegate, lsWatchDelegate, lsLocationDelegate, lsWeatherDelegate {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var trendTable: UITableView!
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
    
    @IBAction func gotoCurrentTap(_ sender: Any) {
        lsData.inSearchMode = false
        reAquireWeather()
    }
    
    @IBAction func creditTap(_ sender: Any) {
        if let url = URL(string: "https://darksky.net/poweredby/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    var lsData = lsModel.sharedInstance
    var watchSession: lsWatchSession?
    var currentLocation: lsLocation?
    var weatherInfo: lsWeather?

    override func viewDidLoad() {
        super.viewDidLoad()

        currentLocation = lsLocation()
        currentLocation!.delegate = self

        watchSession = lsWatchSession()
        watchSession!.delegate = self

        weatherInfo = lsWeather()
        weatherInfo?.delegate = self
        
        
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        loadingView.isHidden = false

        self.navigationController?.navigationBar.titleTextAttributes = (lsiOSHelper.getTitleBarAttributes(light: false) as! [NSAttributedStringKey : Any])
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.foregroundEntered(_:)), name: NSNotification.Name(rawValue: "foregroundEntered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustSEConstraints), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        currentLocation?.startLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        resetScreen()
    }
    
    // Notification Handlers
    @objc func foregroundEntered(_ notification: Notification) {
        reAquireWeather()
    }
    
    @objc func adjustSEConstraints()
    {
        // code to account for SE width
        if UIScreen.main.nativeBounds.width < 700 {
            windLeadingEdge.constant = 55
            dewPointLeadingEdge.constant = 55
            visibilityLeadingEdge.constant = 50
        }
        trendTable.reloadData()
    }

    // screen methods
    func reAquireWeather() {
        if (lsData.inSearchMode){
            resetScreen()
            self.title = "\(lsData.city), \(lsData.state)"
            self.loadLabel.text = "Retrieving weather data for \(lsData.city), \(lsData.state)"
            weatherInfo!.getWeather(longitude: lsData.longitude, latitude: lsData.latitude)
        } else {
            resetScreen()
            currentLocation?.startLocation()
        }
    }
    
    func resetScreen() {
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
    
    func populateScreen() {
        if let ws = watchSession {
            ws.pushLocationText(location: "\(lsData.city), \(lsData.state)")
            ws.pushDataToWatch(data: lsData)
        }

        loadingIndicator.stopAnimating()
        loadingView.isHidden = true

        if (lsData.weatherDays[0].icon == "clear-day") {
            iconImage.image = UIImage(named: "clear-day")
        }
        else if (lsData.weatherDays[0].icon == "clear-night") {
            iconImage.image = UIImage(named: "clear-night")
        }
        else if (lsData.weatherDays[0].icon == "partly-cloudy-day") {
            iconImage.image = UIImage(named: "partly-cloudy-day")
        }
        else if (lsData.weatherDays[0].icon == "partly-cloudy-night") {
            iconImage.image = UIImage(named: "partly-cloudy-night")
        }
        else if (lsData.weatherDays[0].icon == "cloudy") {
            iconImage.image = UIImage(named: "cloudy")
        }
        else if (lsData.weatherDays[0].icon == "rain") {
            iconImage.image = UIImage(named: "rain")
        }
        else if (lsData.weatherDays[0].icon == "sleet") {
            iconImage.image = UIImage(named: "sleet")
        }
        else if (lsData.weatherDays[0].icon == "snow") {
            iconImage.image = UIImage(named: "snow")
        }
        else if (lsData.weatherDays[0].icon == "wind") {
            iconImage.image = UIImage(named: "wind")
        }
        else if (lsData.weatherDays[0].icon == "fog") {
            iconImage.image = UIImage(named: "fog")
        }
        else {
            iconImage.image = UIImage(named: "clear-day")
        }
        
        if ((lsData.weatherDays[0].windBearing > 337.5) || (lsData.weatherDays[0].windBearing <= 22.5)) {
            currentCompassImage.image = UIImage(named: "cp S")
        } else if((lsData.weatherDays[0].windBearing > 22.5) && (lsData.weatherDays[0].windBearing <= 67.5)) {
            currentCompassImage.image = UIImage(named: "cp SW")
        } else if((lsData.weatherDays[0].windBearing > 67.5) && (lsData.weatherDays[0].windBearing <= 112.5)) {
            currentCompassImage.image = UIImage(named: "cp W")
        } else if((lsData.weatherDays[0].windBearing > 112.5) && (lsData.weatherDays[0].windBearing <= 157.5)) {
            currentCompassImage.image = UIImage(named: "cp NW")
        } else if((lsData.weatherDays[0].windBearing > 157.5) && (lsData.weatherDays[0].windBearing <= 202.5)) {
            currentCompassImage.image = UIImage(named: "cp N")
        } else if((lsData.weatherDays[0].windBearing > 202.5) && (lsData.weatherDays[0].windBearing <= 247.5)) {
            currentCompassImage.image = UIImage(named: "cp NE")
        } else if((lsData.weatherDays[0].windBearing > 247.5) && (lsData.weatherDays[0].windBearing <= 292.5)) {
            currentCompassImage.image = UIImage(named: "cp E")
        } else if((lsData.weatherDays[0].windBearing > 292.5) && (lsData.weatherDays[0].windBearing <= 337.5)) {
            currentCompassImage.image = UIImage(named: "cp SE")
        }
        
        currentTempLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].temperature,decimalPlaces: 1))\u{00B0}"
        currentFeelsLikeLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].apparentTemperature,decimalPlaces: 1))\u{00B0}"
        currentHumidityLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].humidity*100,decimalPlaces: 1))%"
        currentWindLabel.text = "\(lsHelper.doubleToString(lsData.weatherDays[0].windSpeed,decimalPlaces: 1)) mph"
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
        
//        webSvcs.track(id: lsData.getID(), city: lsData.city, state: lsData.state, longitude: lsData.longitude, latitude: lsData.latitude, datetime: "\(Int32(Date().timeIntervalSince1970))" )
        
        adjustSEConstraints()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "searchSegue" {
            let destNav = segue.destination as! UINavigationController
            let destCont = destNav.viewControllers[0] as! lsSearchResultsView
            destCont.delegate = self
        }
    }

    // lsSearchDelegate implementation
    func searchLocationSelected(longitude: String, latitude: String, city: String, state: String) {
        lsData.longitude = longitude
        lsData.latitude = latitude
        lsData.city = city
        lsData.state = state
        
        weatherInfo!.getWeather(longitude: longitude, latitude: latitude)
        self.title = "\(city), \(state)"
        self.loadLabel.text = "Retrieving weather data for \(city), \(state)"
    }
    
    
    // lsWatchDelegate implementation
    func getDataForWatch() {
    }
    
    // lsLocationDelegate implementations
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
        weatherInfo!.getWeather(longitude: longitude, latitude: latitude)
    }
    
    func locationString(id: String, city: String, state: String) {
        lsData.city = city
        lsData.state = state
        title = "\(city), \(state)"
        loadLabel.text = "Retrieving weather data for \(city), \(state)"
    }

    // lsWeatherDelegate implementation
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

