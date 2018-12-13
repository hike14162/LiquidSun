import Foundation

public class lsWeatherReport {
    // MARK: - Public members
    public var summary: String
    public var icon: String
    public var time: Date
    public var temperature: Double
    public var apparentTemperature: Double
    public var humidity: Double
    public var windSpeed: Double
    public var windGust: Double
    public var windBearing: Double
    public var precipProbability: Double
    public var visibility: Double
    public var temperatureHigh: Double
    public var temperatureHighTime: Date
    public var temperatureLow: Double
    public var temperatureLowTime: Date
    public var dewPoint: Double
    public var cloudCover: Double
    public var sunriseTime: Date
    public var sunsetTime: Date
    public var data = Data()
    
    //MARK: - Inits
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
    }
    
    // MARK: - Get Methods
    public func getAsDict()->[String:Any]
    {
        let dict: [String: Any] = ["summary":"\(summary)", "temperature":"\(temperature)", "temperatureHigh":"\(temperatureHigh)", "temperatureLow":"\(temperatureLow)","time":"\(time)","humidity":"\(humidity)","windSpeed":"\(windSpeed)","windGust":"\(windGust)","windBearing":"\(windBearing)","apparentTemperature":"\(apparentTemperature)","precipProbability":"\(precipProbability)","icon":"\(icon)","visibility":"\(visibility)","temperatureHighTime":"\(temperatureHighTime)","dewPoint":"\(dewPoint)","cloudCover":"\(cloudCover)","sunriseTime":"\(sunriseTime)","sunsetTime":"\(sunsetTime)"]
        return dict
    }
    
    public func getAsJson()->String {
        let dict: [String: Any] = self.getAsDict()
        let jsonData = try? JSONSerialization.data(withJSONObject: dict)
        let jSonString = NSString(data: jsonData!, encoding:String.Encoding.utf8.rawValue) ?? ""
        return jSonString as String
    }


}
