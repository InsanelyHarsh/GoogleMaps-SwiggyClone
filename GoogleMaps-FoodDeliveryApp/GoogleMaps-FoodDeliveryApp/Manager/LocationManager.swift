//
//  LocationManager.swift
//  Dummy
//
//  Created by Harsh Yadav on 26/05/22.
//

import Combine
import CoreLocation
import GoogleMaps

enum LocationStatus{
    case auth
    case notAuth
    case denied
    case unknown
}

enum AccuracyStatus{
    case full
    case reduced
    case unknown
}

class LocationManager:NSObject,ObservableObject{

    let manager = CLLocationManager()
    let geoManager:GeoCodingManager = GeoCodingManager(gms: GMSGeocoder())
    
    @Published var locationDescription = "...."
    @Published var accuracyStatus:AccuracyStatus = .unknown
    @Published var locationStatus:LocationStatus = .unknown
    @Published var userLocation:String = "<<->>"
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
        didSet{
            Task{
                do{
                    try await self.fetchUserLocation()
                }
                catch{
                    print("Errrrrr.")
                }
            }
        }
    }
    
    var latitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 0
    }
    
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 0
    }
    

    override init() {
        super.init()
        setup()
        updateAuthStatus()
        updateAccuracyStatus()
    }
    
    private func setup(){
        manager.delegate = self
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        
        //after requesting auth call delegate didUpdateLocations
        
//        manager.startUpdatingLocation()
    }
    
    private func updateAuthStatus(){
        switch manager.authorizationStatus{
        case .notDetermined:
            self.locationDescription = "Not Determined"
            self.locationStatus = .notAuth
            
        case .restricted:
            self.locationDescription = "Restricted"
            self.locationStatus = .denied
            
        case .denied:
            self.locationDescription = "Denied"
            self.locationStatus = .denied
            
        case .authorizedAlways:
            self.locationDescription = "Authorized Always"
            self.locationStatus = .auth
            updateAccuracyStatus()
            
        case .authorizedWhenInUse:
            self.locationDescription = "Authorized When In Use"
            self.locationStatus = .auth
            updateAccuracyStatus()
            
        @unknown default:
            self.locationDescription = "Unknown Status"
            self.locationStatus = .unknown
        }
    }
    
    private func updateAccuracyStatus(){
        manager.startUpdatingLocation()
        switch manager.accuracyAuthorization{
        case .fullAccuracy:
            self.locationDescription = "Accurate Location"
            self.accuracyStatus = .full
            self.locationStatus = .auth
            
        case .reducedAccuracy:
            self.locationDescription = "Approximate Location"
            self.locationStatus = .auth
            self.accuracyStatus = .reduced
            
        @unknown default:
            self.locationDescription = "Unknown Accuracy Status"
            self.accuracyStatus = .unknown
        }
    }
    
    func updateLocation(){//TODO: improve... Refactor startUpdatingLocation()
        manager.requestLocation()
        manager.startUpdatingLocation()
    }
    

    func fetchUserLocation() async throws{
        let result = try await geoManager.getPlaceName(of: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
        guard let result = result else {
            //TODO: improve...
            DispatchQueue.main.async {
                self.userLocation =  "Can't Find Place. :("
            }
            return
        }
        //TODO: improve......
        DispatchQueue.main.async {
            self.userLocation = result
        }
    }
}




extension LocationManager:CLLocationManagerDelegate{
    //DID UPDATE/CHANGE location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.updateAuthStatus()
        self.updateAccuracyStatus()
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationDescription = "An Error Occured While Updating User Location" //TODO: improve..
        
        print(">> An Error Occured While Updating User Location. \n")
        print(">> Error: \(error.localizedDescription) \n \n")
        
    }
    
    //DID CHANGE AUTH status
    /// whenever auth is changed:
    ///-> Update Location Status
    ///-> Update Location of User
     func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
         
        let status = manager.authorizationStatus
        let accuracyStatus = manager.accuracyAuthorization
            
         self.updateAuthStatus()
         self.updateAccuracyStatus()
         
        if((status == .authorizedWhenInUse) || (status == .authorizedAlways)){
            if (accuracyStatus == .reducedAccuracy){
                //TODO: improve this do..
//                do{
                    
//                    try await manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation")
                    
                    if (accuracyStatus == .fullAccuracy){
                        self.locationDescription = "Full Accuracy Location Access Granted."
                    }
                    else if (accuracyStatus == .reducedAccuracy){
                        self.locationDescription = "Approx Location As User Denied Accurate Location Access"
                        
                    }
                    
                    manager.startUpdatingLocation()
//                }
//                catch{
//                    locationDescription = "An Error Occured While Requesting Temporaray Full Accuracy Auth"
//                }
            }
            else if(accuracyStatus == .fullAccuracy){
                
                self.locationDescription = "Accurate Location"
                manager.startUpdatingLocation()
            }
        }
    }
}
