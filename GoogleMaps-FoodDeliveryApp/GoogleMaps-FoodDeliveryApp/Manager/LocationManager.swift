    //
    //  LocationManager.swift
    //  Dummy
    //
    //  Created by Harsh Yadav on 26/05/22.
    //

import Combine
import CoreLocation


class HomeViewModel:ObservableObject{
    @Published var locationStatus:String = ""
    @Published var location:CLLocation?{
        willSet{
            objectWillChange.send()
        }
    }
    
    var latitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 0
    }
    
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 0
    }
    
    let locationManager:LocationManager
    init(locationManager:LocationManager){
        self.locationManager = locationManager
    }
    
    func getLatestLocation(){
        
    }
}


class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var locationStatus = "..."
        // 1
    @Published var location: CLLocation? {
        willSet { objectWillChange.send() }
    }
    
        // 2
    var latitude: CLLocationDegrees {
        return location?.coordinate.latitude ?? 0
    }
    
    var longitude: CLLocationDegrees {
        return location?.coordinate.longitude ?? 0
    }
    
        // 3
    override init() {
        super.init()
        
        setup()
    }
    
    private func setup(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
    }
    
    
    func checkLocationAccuracyAllowed() {
        locationManager.startUpdatingLocation()
        
        switch locationManager.accuracyAuthorization {
        case .reducedAccuracy:
            locationStatus = "approximate location"
        case .fullAccuracy:
            locationStatus = "accurate location"
        @unknown default:
            locationStatus = "unknown type"
        }
        
    }
    
    func authStatus(){
        switch locationManager.authorizationStatus{
        case .authorizedAlways:
            locationStatus = "authorized always"
            checkLocationAccuracyAllowed()
        case .authorizedWhenInUse:
            locationStatus = "authorized when in use"
            checkLocationAccuracyAllowed()
        case .notDetermined:
            locationStatus = "not determined"
        case .restricted:
            locationStatus = "restricted"
        case .denied:
            locationStatus = "denied"
        default:
            locationStatus = "other"
        }
    }
    
    func requestLocationAuth() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyReduced
        
        authStatus()
    }
    
    func updateLocation(){
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
    }
}



extension LocationManager: CLLocationManagerDelegate {

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Started Updating Location")
        guard let location = locations.last else { return }
        self.location = location
        print(">>>>> \(location.coordinate.latitude),\(location.coordinate.longitude)")
        authStatus()
        print("Updated Location")
        manager.stopUpdatingLocation()
        print("Stoped updating Location.")
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("And Error Occured wile Updating Loacations.")
    }
    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        let accuracyStatus = manager.accuracyAuthorization
        
        if (status == .authorizedAlways || status == .authorizedWhenInUse){
            if (accuracyStatus == CLAccuracyAuthorization.reducedAccuracy){
                locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "wantAccurateLocation", completion: { [self]
                    error in
                    
                    if locationManager.accuracyAuthorization == .fullAccuracy{
                        locationStatus = "Full Accuracy Location Access Granted Temporarily"
                    }
                    else{
                        locationStatus = "Approx Location As User Denied Accurate Location Access"
                    }
                    locationManager.startUpdatingLocation()
                })
            }
        }
        else{
            requestLocationAuth()
        }
    }
    

}

class Location:NSObject{
    @Published var authorizationStatus:String = "Not Determined"
    let manager = CLLocationManager()
    
    override init() {
        super.init()
        print("Location Class in inited")
    }
    
    func setup(){
//        manager.delegate = self
//        manager.requestLocation()
        
        manager.requestAlwaysAuthorization()
        manager.requestWhenInUseAuthorization()
//        manager.requestLocation()
        
        switch manager.authorizationStatus{
            case .notDetermined:
                self.authorizationStatus = "Not Determined"
                print("Not Determined")
            case .restricted:
                self.authorizationStatus = "Restricted"
                print("Restricted")
            case .denied:
                self.authorizationStatus = "Denied"
                print("Denied")
            case .authorizedAlways:
                self.authorizationStatus = "Authorized Always"
                print("Authorized Always")
            case .authorizedWhenInUse:
                self.authorizationStatus = "Authorized When In Use"
                print("Authorized When In Use")
            @unknown default:
                self.authorizationStatus = "Unknown"
                print("Unknown")
        }
        if CLLocationManager.locationServicesEnabled(){
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager.startUpdatingLocation()
            manager.startUpdatingLocation()
        }
        else{
            print("Please Provde Location Permission")
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
        }
//        guard CLLocationManager.locationServicesEnabled() else{
//            manager.requestLocation()
//            print("Please Provide Location Perminssion")
//            return
//        }
        
        
    }
    
    
    func extras(){
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension Location:CLLocationManagerDelegate {
        // 4
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
        
//        if let location = locations.first{
//            manager.stopUpdatingLocation()
//            print(location.coordinate)
//        }
//        guard let location = locations.last else { return }
//        self.location = location
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Changed Auth Status")
        switch manager.authorizationStatus{
        case .notDetermined:
            self.authorizationStatus = "Not Determined"
            print("Not Determined")
        case .restricted:
            self.authorizationStatus = "Restricted"
            print("Restricted")
        case .denied:
            self.authorizationStatus = "Denied"
            print("Denied")
        case .authorizedAlways:
            self.authorizationStatus = "Authorized Always"
            print("Authorized Always")
        case .authorizedWhenInUse:
            self.authorizationStatus = "Authorized When In Use"
            print("Authorized When In Use")
        @unknown default:
            self.authorizationStatus = "Unknown"
            print("Unknown")
        }
    }
}
