import Foundation

class lsRESTServices
{
    func getWeatherHistory(longitude: String, latitude: String, date: Date)
    {
        let urlString = "https://api.darksky.net/forecast/0af818c07d981c24834f044aa8609ac5/\(latitude),\(longitude),\(Int32(date.timeIntervalSince1970))"
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
                                        }
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "weatherDayAdd"), object:currentObj)

//                                    }
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
