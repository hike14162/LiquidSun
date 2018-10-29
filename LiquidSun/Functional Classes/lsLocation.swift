import Foundation
import CoreLocation

class lsLocation: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager = CLLocationManager()
    var delegate: lsLocationDelegate? = nil
    var id = ""
    var searchOK = true
    
    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startLocation() {
        id = lsHelper.getGUID()
        if CLLocationManager.locationServicesEnabled() {
            searchOK = true
            locationManager.startUpdatingLocation()
        } else {
            delegate!.locationDenied(id: id)
        }
    }

    func getID() -> String {
        return self.id
    }
    
    // Location delegate implementations
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .denied) {
            delegate!.locationDenied(id: id)
        } else if ((status == .authorizedAlways) || (status == .authorizedWhenInUse)) {
            delegate!.locationAuthorized(id: id)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (searchOK) {
            searchOK = false
            locationManager.stopUpdatingLocation()
            CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) in
                if (error != nil) {
                    return
                }
                
                if (placemarks?.count)! > 0 {
                    let pm = placemarks![0] as CLPlacemark
                    self.delegate!.locationString(id: self.id, city: pm.locality ?? "", state: pm.administrativeArea ?? "")
                } else {
                    print("Problem with the data received from geocoder")
                }
            })
            
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            
            let currentLoc: CLLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
            delegate?.locationFound(id: id, longitude: "\(currentLoc.coordinate.longitude)", latitude: "\(currentLoc.coordinate.latitude)")
        }
    }
    
}
