import Foundation

protocol lswWeatherDelegate {
    func weatherDataReceived(weatherData: [Data])
    func updateCityStateLabel(locationString: String)
    
    func iPhoneNotReachable()
    func iPhoneReachable()
}
