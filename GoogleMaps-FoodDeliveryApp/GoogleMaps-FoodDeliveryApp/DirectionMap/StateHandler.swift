//
//  StateHandler.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 22/07/22.
//

import Foundation
import CoreLocation
import GoogleMaps
import Combine

class StateHandler:ObservableObject{
    
    @Published var userDropLocation:CLLocationCoordinate2D? //Location user selected in DirectionSearchView
    @Published var userPickupLocation:CLLocationCoordinate2D?
    
    @Published var didSelectCurrentPickLocation:Bool = false
    @Published var didSelectionCurrentDropLocation:Bool = false
    
    @Published var updatedPickupLocation:CLLocationCoordinate2D?
    @Published var updatedDropLocation:CLLocationCoordinate2D?
    
    @Published var updatedState:GMSCameraPosition? //prev rakh rhe hai isme...
    @Published var currentState:GMSCameraPosition? //ye show ho rhi hai user ko......
    
    var direction:DirectionLocationManager = DirectionLocationManager()
    var cancellables:Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(){
//        logic()

//        self.currentState = GMSCameraPosition.camera(withLatitude: self.userPickupLocation!.latitude, longitude: self.userPickupLocation!.longitude, zoom: 15)
//
//        self.updatedState = currentState
    }
    
    
    func logic(){
        direction.$location.sink { [self] newLocation in
            if(didSelectionCurrentDropLocation){
                self.updatedDropLocation = newLocation?.coordinate
                
                self.currentState = updatedState
                
            }else if(didSelectCurrentPickLocation){
                self.updatedPickupLocation = newLocation?.coordinate
                self.currentState = updatedState
            }
        }
        .store(in: &cancellables)
    }
}
