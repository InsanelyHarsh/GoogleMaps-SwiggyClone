//
//  MapManager.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 27/05/22.
//

import GooglePlaces
import GoogleMaps


protocol MapProtocol{
    ///Search Google Places from given query. This function will give array of Result.
    func findPlaces(query:String,completionHandler: @escaping(Result<[SearchResultModel],Error>) -> Void)
    
    ///Get Coordinates from Place Name.
    func fetchCoordinates( for place:SearchResultModel,completionHandler: @escaping(Result<CLLocationCoordinate2D,Error>)->Void )
    
    ///Gives Place Name from Coordinates. This is async function.
    func getPlaceName(of coordinate:CLLocationCoordinate2D) async throws -> String?
}


class MapManager:MapProtocol{
    static let shared = GMSPlacesClient.shared()
    
    ///Search Google Places from given query. This function will give array of Result.
    func findPlaces(query:String,completionHandler: @escaping(Result<[SearchResultModel],Error>) -> Void) {
        
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        
        SearchManager.shared.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { result, error in
            
            guard let result = result, error == nil else { return completionHandler(.failure(GooglePlacesSearchError.noResult))  }
            
            completionHandler(.success(result.compactMap{SearchResultModel(placeID: $0.placeID, placeName: $0.attributedFullText.string)}))
        }
    }
    
    ///Get Coordinates from Place Name.
    func fetchCoordinates( for place:SearchResultModel,completionHandler: @escaping(Result<CLLocationCoordinate2D,Error>)->Void ){
        SearchManager.shared.fetchPlace(fromPlaceID: place.placeID, placeFields: .coordinate, sessionToken: nil) { googlePlace, err in
            guard err == nil else{
                return completionHandler(.failure(GooglePlacesSearchError.noResult))
            }
            
            guard let googlePlace = googlePlace else{
                return completionHandler(.failure(GooglePlacesSearchError.noResult))
            }
            completionHandler(.success(googlePlace.coordinate))
        }
    }
    
    ///Gives Place Name from Coordinates. This is async function.
    func getPlaceName(of coordinate:CLLocationCoordinate2D) async throws -> String?{
        print("Manager is being called")
        let gms = GMSGeocoder()
        do{
            let x = try await gms.reverseGeocodeCoordinate(coordinate)
            print("Manger Returning something")
            return x.firstResult()?.country
            
        }
        catch{
            print("error occurrred")
            return nil
        }
    }
}
