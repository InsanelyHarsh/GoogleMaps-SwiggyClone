//
//  DirectionLocationManager.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 21/07/22.
//

import Foundation
import CoreLocation

class DirectionLocationManager:NSObject,ObservableObject{
    let manager = CLLocationManager()

    @Published var location: CLLocation?

    override init() {
        super.init()
        setup()
    }

    private func setup(){
        manager.delegate = self

        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        startUpdating()
    }

    func updateLocation(){//TODO: improve... Refactor startUpdatingLocation()
        manager.requestLocation()
        self.startUpdating()
    }

    func stopUpdating(){
        manager.stopUpdatingLocation()
    }

    func startUpdating(){
        manager.startUpdatingLocation()
    }

    deinit{
        manager.stopUpdatingLocation()
        print("Stoped Updating Location!!")
    }
}


extension DirectionLocationManager:CLLocationManagerDelegate{
    //DID UPDATE/CHANGE location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        self.location = location
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(">> An Error Occured While Updating User Location. \n")
        print(">> Error: \(error.localizedDescription) \n \n")
        manager.stopUpdatingLocation()
    }
}
