protocol lsLocationDelegate {
    func locationDenied(id: String)
    func locationAuthorized(id: String)
    
    func locationFound(id: String, longitude: String, latitude: String)
    func locationString(id: String, city: String, state: String)
}
