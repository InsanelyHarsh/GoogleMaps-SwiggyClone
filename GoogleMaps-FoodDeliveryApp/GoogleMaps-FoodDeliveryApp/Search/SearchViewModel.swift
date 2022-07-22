    //
    //  SearchViewModel.swift
    //  Dummy
    //
    //  Created by Harsh Yadav on 26/05/22.
    //

import Foundation
import CoreLocation


class SearchViewModel:ObservableObject{
    
//    let manager:GoogleMapManager
    
    let manager:SearchManager
    let locationManager:LocationManager
    
    init(manager:SearchManager,locationManager:LocationManager){
        self.manager = manager
        self.locationManager = locationManager
    }
    
    @Published var placeResult:[SearchResultModel] = []
    @Published var query:String = ""
    @Published var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 4.4, longitude: 6.6)
    
    func getData(){
        manager.findPlaces(query: query) { [weak self] result in
            switch result{
                
            case .success(let result):
                self?.placeResult = result //on Main Thread.
                
            case .failure(let error):
                print(error) //TODO: improve...
            }
        }
    }
    
    func getCoordinates(for place:SearchResultModel){
        manager.fetchCoordinates(for: place) { [weak self] result in
            switch result{
            case .success(let coordinates):
                self?.coordinate = coordinates
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getCurrentLocation(){
        self.coordinate = CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
    }
}
