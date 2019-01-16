import Foundation
import CoreLocation

class lsLocation: NSObject {
    // MARK: - Member variables
    var locationManager: CLLocationManager = CLLocationManager()
    var delegate: lsLocationDelegate? = nil
    var id = ""
    var searchOK = true
    
    // MARK: - Overrides
    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Methods
    func startLocation() {
        id = lsHelper.getGUID()
        if CLLocationManager.locationServicesEnabled() {
            searchOK = true
            locationManager.startUpdatingLocation()
        } else {
            if let dlgt = delegate {
                dlgt.locationDenied(id: id)
            }
        }
    }

    func getID() -> String {
        return self.id
    }
}

// MARK: - CLLocationManagerDelegate Implementation
extension lsLocation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let dlgt = delegate {
            if (status == .denied) {
                dlgt.locationDenied(id: id)
            } else if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
                dlgt.locationAuthorized(id: id)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (searchOK) {
            searchOK = false
            locationManager.stopUpdatingLocation()
            if let loc = manager.location {
                CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                    if (error != nil) {
                        return
                    }
                    
                    if let plcMk = placemarks {
                        if (plcMk.count) > 0 {
                            let pm = plcMk[0] as CLPlacemark
                            self.delegate!.locationString(id: self.id, city: pm.locality ?? "", state: pm.administrativeArea ?? "")
                        } else {
                            print("Problem with the data received from geocoder")
                        }
                    }
                })
            }
            
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as? CLLocation
            if let locObj = locationObj {
                let coord = locObj.coordinate
                let currentLoc: CLLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                if let dlgt = delegate {                    
                    dlgt.locationFound(id: id, longitude: "\(currentLoc.coordinate.longitude)", latitude: "\(currentLoc.coordinate.latitude)")
                }
            }
            
        }
    }

}
