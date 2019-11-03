protocol  lsWeatherDelegate {
    //MARK: - Reachability required method definition
    func networkNotReachable()
    func networkReachable()
    
    //MARK: - Required method definition
    func weatherRetrieved(id: String, weatherDays: [lsWeatherReport], averages: lsTrend)
}
