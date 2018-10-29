import Foundation
import CoreLocation

class lswNativeFetch: NSObject, CLLocationManagerDelegate, lsRESTServicesDelegate {
    func weatherDayReturned(weatherDay: lsWeatherReport) {
        print(weatherDay.temperature)
    }
    
    var locationManager: CLLocationManager = CLLocationManager()
    var delegate: lsLocationDelegate! = nil

    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    public func beginTransfer() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied {
            print("location denied")
        } else {
            print("location ok")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        let currentLoc: CLLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)

        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) in
            if (error != nil) {
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks![0] as CLPlacemark

                self.delegate!.locationString(id: "", city: pm.locality ?? "", state: pm.administrativeArea ?? "")
                self.delegate!.locationFound(id: "", longitude: "\(currentLoc.coordinate.longitude)", latitude: "\(currentLoc.coordinate.latitude)")
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }

    
}
