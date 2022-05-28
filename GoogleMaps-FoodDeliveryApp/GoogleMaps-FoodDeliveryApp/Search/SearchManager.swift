    //
    //  SearchManager.swift
    //  Dummy
    //
    //  Created by Harsh Yadav on 26/05/22.
    //

    import Foundation
    import GooglePlaces
    import CoreLocation
    enum GooglePlacesSearchError:Error{
        case unknownError
        case noResult
        
    }

    class SearchManager{

        static let shared = GMSPlacesClient.shared()
        
        func findPlaces(query:String,completionHandler: @escaping(Result<[SearchResultModel],Error>) -> Void) {
            
            let filter = GMSAutocompleteFilter()
            filter.type = .geocode
            
            SearchManager.shared.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { result, error in
                
                guard let result = result, error == nil else { return completionHandler(.failure(GooglePlacesSearchError.noResult))  }
                
                completionHandler(.success(result.compactMap{SearchResultModel(placeID: $0.placeID, placeName: $0.attributedFullText.string)}))
            }
        }
        
        
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
    }


