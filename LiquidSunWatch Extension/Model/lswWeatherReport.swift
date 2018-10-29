import Foundation

class XlswWeatherReport {
    var summary: String
    var icon: String
    var time: Date
    var temperature: Double
    var apparentTemperature: Double
    var humidity: Double
    var windSpeed: Double
    var windGust: Double
    var windBearing: Double
    var precipProbability: Double
    var visibility: Double
    var temperatureHigh: Double
    var temperatureHighTime: Date
    var temperatureLow: Double
    var temperatureLowTime: Date
    var dewPoint: Double
    var cloudCover: Double
    var sunriseTime: Date
    var sunsetTime: Date
    
    init(jsonData: Data) {
        summary = ""
        temperature =  0.0
        temperatureHigh =  0.0
        temperatureLow =  0.0
        time = Date(timeIntervalSince1970: Double(0.0))
        humidity = 0.0
        windSpeed = 0.0
        windGust = 0.0
        windBearing = 0.0
        apparentTemperature = 0.0
        precipProbability = 0.0
        icon = ""
        visibility = 0.0
        temperatureHighTime = Date(timeIntervalSince1970: Double(0.0))
        temperatureLowTime = Date(timeIntervalSince1970: Double(0.0))
        dewPoint = 0.0
        cloudCover = 0.0
        sunriseTime = Date(timeIntervalSince1970: Double(0.0))
        sunsetTime = Date(timeIntervalSince1970: Double(0.0))

        do {
            if let fullDoc = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any] {
                if let json = fullDoc["currently"] as? [String: Any] {
                    summary = json["summary"] as? String ?? ""
                    temperature = json["temperature"] as? Double ?? 0.0
                    temperatureHigh = json["temperatureHigh"] as? Double ?? 0.0
                    temperatureLow = json["temperatureLow"] as? Double ?? 0.0
                    time = Date(timeIntervalSince1970: Double((json["time"] as? Double) ?? 0.0))
                    humidity = json["humidity"] as? Double ?? 0.0
                    windSpeed = json["windSpeed"] as? Double ?? 0.0
                    windGust = json["windGust"] as? Double ?? 0.0
                    windBearing = json["windBearing"] as? Double ?? 0.0
                    apparentTemperature = json["apparentTemperature"] as? Double ?? 0.0
                    precipProbability = json["precipProbability"] as? Double ?? 0.0
                    icon = json["icon"] as? String ?? ""
                    visibility = json["visibility"] as? Double ?? 0.0
                    temperatureHighTime = Date(timeIntervalSince1970: Double((json["temperatureHighTime"] as? Double) ?? 0.0))
                    temperatureLowTime = Date(timeIntervalSince1970: Double((json["temperatureLowTime"] as? Double) ?? 0.0))
                    dewPoint = json["dewPoint"] as? Double ?? 0.0
                    cloudCover = json["cloudCover"] as? Double ?? 0.0
                    sunriseTime = Date(timeIntervalSince1970: Double((json["sunriseTime"] as? Double) ?? 0.0))
                    sunsetTime = Date(timeIntervalSince1970: Double((json["sunsetTime"] as? Double) ?? 0.0))
                }
            }
        }
        catch {
        }
    }
    
    init(json:[String:Any]) throws {
        summary = json["summary"] as? String ?? ""
        temperature = json["temperature"] as? Double ?? 0.0
        temperatureHigh = json["temperatureHigh"] as? Double ?? 0.0
        temperatureLow = json["temperatureLow"] as? Double ?? 0.0
        time = Date(timeIntervalSince1970: Double((json["time"] as? Double) ?? 0.0))
        humidity = json["humidity"] as? Double ?? 0.0
        windSpeed = json["windSpeed"] as? Double ?? 0.0
        windGust = json["windGust"] as? Double ?? 0.0
        windBearing = json["windBearing"] as? Double ?? 0.0
        apparentTemperature = json["apparentTemperature"] as? Double ?? 0.0
        precipProbability = json["precipProbability"] as? Double ?? 0.0
        icon = json["icon"] as? String ?? ""
        visibility = json["visibility"] as? Double ?? 0.0
        temperatureHighTime = Date(timeIntervalSince1970: Double((json["temperatureHighTime"] as? Double) ?? 0.0))
        temperatureLowTime = Date(timeIntervalSince1970: Double((json["temperatureLowTime"] as? Double) ?? 0.0))
        dewPoint = json["dewPoint"] as? Double ?? 0.0
        cloudCover = json["cloudCover"] as? Double ?? 0.0
        sunriseTime = Date(timeIntervalSince1970: Double((json["sunriseTime"] as? Double) ?? 0.0))
        sunsetTime = Date(timeIntervalSince1970: Double((json["sunsetTime"] as? Double) ?? 0.0))
    }}
