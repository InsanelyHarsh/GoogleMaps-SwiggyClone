//
//  DirectionSearchViewModel.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 20/07/22.
//

import Foundation
import CoreLocation
import GoogleMaps

class DirectionSearchViewModel:ObservableObject{
    @Published var seachResults:[SearchResultModel] = []
    
    @Published var query:String = ""
    @Published var coordinate:CLLocationCoordinate2D?
//    = CLLocationCoordinate2D(latitude: 30.0869281, longitude: 78.2676116)
    @Published var currentLocationName:String = ""
    
    @Published var showAlert:Bool = false
    @Published var alertMsg:String = ""
    
    @Published var isloading:Bool = false
    
    let searchManager:SearchManager
    let locationManager:LocationManager
    let geoCodingManager:GeoCodingManager = GeoCodingManager(geoCoder: GMSGeocoder())
    
    
    init(searchManager:SearchManager,locationManager:LocationManager){
        self.searchManager = searchManager
        self.locationManager = locationManager
    }
    
    
    func searchLocation(){
        self.searchManager.findPlaces(query: self.query) { result in
            switch result{
            case .success(let success):
                self.seachResults = success
            case .failure(let failed):
                print("Failed: \(failed.localizedDescription)")
            }
        }
    }
    
    
    func getCoordinates(for place:SearchResultModel){
        self.isloading = true
        self.searchManager.fetchCoordinates(for: place) {  result in
            switch result{
            case .success(let coordinates):
                self.coordinate = coordinates
                self.isloading = false
            case .failure(let error):
                print(error)
                self.isloading = false
            }
        }
    }
    

    func getCurrentLocation() async{
        self.coordinate = CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
        await self.getLocationName()
    }
    
   
    func getLocationName() async{
        do{
            guard let coordinate = coordinate else {
                return
            }
            let x = try await self.geoCodingManager.getPlaceName(of: coordinate) ?? "Unknown Current Location"
            await MainActor.run {
                self.currentLocationName = x
            }
        }
        catch{
            print("Error")
        }
    }
}
