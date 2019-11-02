import Foundation

final class lsRESTServices
{
    // MARK: - Public methods
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
    
    private func adjustForTimeZones(date: Date)->Date? {
        let lsData = lsModel.sharedInstance
        let calendar = Calendar.current
        let adjustedDate = calendar.date(byAdding: .second, value: lsData.GMTOffsetSeconds, to: date)
        print("date: \(date)  Adjust: \(adjustedDate)")
        return adjustedDate
    }
    
    func getWeatherCurrentForecast(longitude: String, latitude: String, completion: @escaping (lsWeatherReport?, Error?) -> Void) {
        let urlString = "https://api.darksky.net/forecast/0af818c07d981c24834f044aa8609ac5/\(latitude),\(longitude)?exclude=minutely,hourly,alerts"

        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.none , error)
                print(error!.localizedDescription)
            }
            
//                        let responseStr:NSString = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)!
//                        print(responseStr)
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let result = json["currently"] as? [String: Any] {
                            if let currentObj = try? lsWeatherReport(json: result) {
                                // get forecast high and low
                                if let dailySect = json["daily"] as? [String: Any] {
                                    if let dailyArr = dailySect["data"] as? [[String: Any]] {
                                        for (i, day) in dailyArr.enumerated() {
                                            if let report = try? lsWeatherReport(json: day) {
                                                if let adjDate = self.adjustForTimeZones(date: report.time) {
                                                    report.time = adjDate
                                                }

                                                if i == 0 { // Current report
                                                    currentObj.temperatureHigh = report.temperatureHigh
                                                    currentObj.temperatureLow = report.temperatureLow
                                                    currentObj.temperatureHighTime = report.temperatureHighTime
                                                    currentObj.temperatureLowTime = report.temperatureLowTime
                                                    currentObj.precipProbability = report.precipProbability
                                                    currentObj.sunriseTime = report.sunriseTime
                                                    currentObj.sunsetTime = report.sunsetTime
                                                    currentObj.data = data
                                                }
                                                
                                                //add forecast
                                                currentObj.forecast.append(lsWeatherForecast(dayOfWeek: lsHelper.DateToDOWString(report.time), lowTemp: report.temperatureLow, highTemp: report.temperatureHigh, percip: report.precipProbability*100, icon: report.icon))
                                            }
                                        }
                                        
                                    }
                                }
                                DispatchQueue.main.async {
                                    completion(currentObj, .none)
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
    
    func getWeatherHistory(longitude: String, latitude: String, date: Date, completion: @escaping (lsWeatherReport?, Error?) -> Void) {
        
        var urlString = ""
        let cal = Calendar.current
        
        // get full daily forecast if date is today
        if cal.isDateInToday(date) {
            urlString = "https://api.darksky.net/forecast/0af818c07d981c24834f044aa8609ac5/\(latitude),\(longitude)?exclude=minutely,hourly,alerts"
        } else {
            urlString = "https://api.darksky.net/forecast/0af818c07d981c24834f044aa8609ac5/\(latitude),\(longitude),\(Int32(date.timeIntervalSince1970))?exclude=minutely,hourly,alerts"
        }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.none , error)
                print(error!.localizedDescription)
            }
            
            //            let responseStr:NSString = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)!
            //            print(responseStr)
            
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
                                    completion(currentObj, .none)
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

