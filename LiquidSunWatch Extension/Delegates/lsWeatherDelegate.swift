import Foundation

protocol  lsWeatherDelegate {
    func networkNotReachable()
    func networkReachable()
    func weatherRetrieved(id: String, weatherDays: [lsWeatherReport])
}
