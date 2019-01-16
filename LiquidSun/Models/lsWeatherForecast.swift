import Foundation

public class lsWeatherForecast {
    var dayOfWeek: String
    var lowTemp: Double
    var highTemp: Double
    var percip: Double
    var icon: String
    
    init(dayOfWeek: String, lowTemp: Double, highTemp: Double, percip: Double, icon: String) {
        self.dayOfWeek = dayOfWeek
        self.lowTemp = lowTemp
        self.highTemp = highTemp
        self.percip = percip
        self.icon = icon
    }
    
}
