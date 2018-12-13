import Foundation 

protocol lswWeatherDelegate {
    //MARK: - Required method definition
    func weatherDataReceived(weatherData: [Data])
    func updateCityStateLabel(locationString: String)
    
    //MARK: - Required Reachability method definition
    func iPhoneNotReachable()
    func iPhoneReachable()
}
