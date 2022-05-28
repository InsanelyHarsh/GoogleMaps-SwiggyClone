//
//  MapViewModel.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 27/05/22.
//

import Foundation
import CoreLocation

class MapViewModel:ObservableObject{
    let mapManager = MapManager()
    @Published var placeName:String = ""
    init(){
        
    }
    
    func getPlaceName(of coordinate:CLLocationCoordinate2D) async{
        print("VM is getting called")
        do{
            let name = try await mapManager.getPlaceName(of: coordinate)
            guard let name = name else {
                return
            }
            print("name is saved")
            DispatchQueue.main.async {
                self.placeName = name
            }
        }
        catch{
            print("Error aa gaya.")
        }
    }
}
