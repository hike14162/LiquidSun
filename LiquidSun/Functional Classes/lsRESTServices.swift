import Foundation

class lsRESTServices
{
    var delegate: lsRESTServicesDelegate!
    
    func track(id: String, city: String, state: String, longitude: String, latitude: String, datetime: String) {
        // Create json Data
        let log: [String: Any] = ["ID":"\(id)", "City":"\(city)", "State":"\(state)", "Longitude":"\(longitude)", "Latitude":"\(latitude)", "DateTime":"\(datetime)"]
        let json: [String: Any] = ["value": log]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        //****

        let urlString = "https://epgateway.envelopeplusapp.com/weather/WeatherLog.svc/log"
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            if let data = data {
                print(NSString(data:data as Data, encoding:String.Encoding.utf8.rawValue) ?? "")
            }
            
            }.resume()

    }

    func getWeatherHistory(longitude: String, latitude: String, date: Date) {
        let urlString = "https://api.darksky.net/forecast/0af818c07d981c24834f044aa8609ac5/\(latitude),\(longitude),\(Int32(date.timeIntervalSince1970))?exclude=minutely,hourly,alerts"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {                        
                        if let result = json["currently"] as? [String: Any] {
                            if let currentObj = try? lsWeatherReport(json: result) {
                                
                                // get forecast high and low
                                if let dailySect = json["daily"] as? [String: Any] {
                                    if let dailyArr = dailySect["data"] as? [[String: Any]] {
                                        if let forecast = try? lsWeatherReport(json: dailyArr[0]) {
                                            currentObj.temperatureHigh = forecast.temperatureHigh
                                            currentObj.temperatureLow = forecast.temperatureLow
                                            currentObj.temperatureHighTime = forecast.temperatureHighTime
                                            currentObj.temperatureLowTime = forecast.temperatureLowTime
                                            currentObj.precipProbability = forecast.precipProbability
                                            currentObj.sunriseTime = forecast.sunriseTime
                                            currentObj.sunsetTime = forecast.sunsetTime
                                            currentObj.data = data
                                        }
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    self.delegate!.weatherDayReturned(weatherDay: currentObj)
                                }
                            }
                        }
                        
                    }
                }
                catch {
                    print(error.localizedDescription)
                }
            }
            }.resume()
    }

}
