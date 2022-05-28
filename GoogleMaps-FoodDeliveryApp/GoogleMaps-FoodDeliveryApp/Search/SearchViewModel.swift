    //
    //  SearchViewModel.swift
    //  Dummy
    //
    //  Created by Harsh Yadav on 26/05/22.
    //

    import Foundation
    import CoreLocation
    class SearchViewModel:ObservableObject{
        
        let manager = MapManager()
        @Published var placeResult:[SearchResultModel] = []
        @Published var query:String = ""
        @Published var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 4.4, longitude: 6.6)
        
        @Published var isLoading:Bool = false
//        let manager = SearchManager()
        
        func getData(){
            print("Calling for: \(query)")
            manager.findPlaces(query: query) { [weak self] result in
                switch result{
                case .success(let result):
                    self?.placeResult = result //on Main Thread.
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func getCoordinates(for place:SearchResultModel){
            manager.fetchCoordinates(for: place) { [weak self] result in
                switch result{
                case .success(let coordinates):
                    self?.coordinate = coordinates
    //                print(coordinates)
    //                self?.isLoading = true
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
