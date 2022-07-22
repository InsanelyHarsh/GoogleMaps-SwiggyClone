//
//  SearchManager.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 18/07/22.
//

import Foundation
import GooglePlaces

class SearchManager:GooglePlacesProtocol{
    static let googlePlacesClient = GMSPlacesClient.shared()
    
    ///Search Google Places from given query. This function will give array of Result.
    func findPlaces(query:String,completionHandler: @escaping(Result<[SearchResultModel],Error>) -> Void) {
        
        let filter = GMSAutocompleteFilter()
        
        filter.type = .noFilter
        filter.countries = ["IND"]
        
        
        SearchManager.googlePlacesClient.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { result, error in
            
            guard let result = result, error == nil else { return completionHandler(.failure(GooglePlacesSearchError.noResult))  }
            
            completionHandler(.success(result.compactMap{SearchResultModel(placeID: $0.placeID, placeName: $0.attributedFullText.string)}))
        }
    }
    
    
    ///Get Coordinates from Place Name.
    func fetchCoordinates( for place:SearchResultModel,completionHandler: @escaping(Result<CLLocationCoordinate2D,Error>)->Void ){

        SearchManager.googlePlacesClient.fetchPlace(fromPlaceID: place.placeID, placeFields: .coordinate, sessionToken: nil) { googlePlace, err in
            guard err == nil else{
                return completionHandler(.failure(GooglePlacesSearchError.noResult))
            }
            
            guard let googlePlace = googlePlace else{
                return completionHandler(.failure(GooglePlacesSearchError.noResult))
            }
            
            completionHandler(.success(googlePlace.coordinate))
        }
    }
    
    
}
