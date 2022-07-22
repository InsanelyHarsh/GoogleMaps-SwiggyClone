//
//  HomeViewModel.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 30/05/22.
//

import Foundation
import CoreLocation
import GoogleMaps

class HomeViewModel:ObservableObject{
    let manager:GeoCodingManager = GeoCodingManager(geoCoder: GMSGeocoder())
    let locationManager:LocationManager
    
    init(locationManager:LocationManager){
        self.locationManager = locationManager
    }
    
    
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

    func getLatestLocation(){
        
    }
}

