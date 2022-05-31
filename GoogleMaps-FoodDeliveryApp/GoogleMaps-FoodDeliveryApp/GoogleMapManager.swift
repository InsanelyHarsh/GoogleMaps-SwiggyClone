//
//  MapManager.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 27/05/22.
//

import GooglePlaces
import GoogleMaps

enum GooglePlacesSearchError:Error{
    case unknownError
    case noResult
    
}


protocol GeocodingProtocol{
        ///Gives Place Name from Coordinates. This is async function.
    func getPlaceName(of coordinate:CLLocationCoordinate2D) async throws -> String?
}

protocol GooglePlacesProtocol{
        ///Search Google Places from given query. This function will give array of Result.
        func findPlaces(query:String,completionHandler: @escaping(Result<[SearchResultModel],Error>) -> Void)
    
        ///Get Coordinates from Place Name.
        func fetchCoordinates( for place:SearchResultModel,completionHandler: @escaping(Result<CLLocationCoordinate2D,Error>)->Void )
}


//TODO: Genrics....
//TODO: Error Handling....
class GoogleMapManager:GooglePlacesProtocol,GeocodingProtocol{
    
    static let shared = GMSPlacesClient.shared()
    
    let gms:GMSGeocoder
    init(gms:GMSGeocoder){
        self.gms = gms
    }
    
    
    ///Search Google Places from given query. This function will give array of Result.
    func findPlaces(query:String,completionHandler: @escaping(Result<[SearchResultModel],Error>) -> Void) {
        
        let filter = GMSAutocompleteFilter()
        
        filter.type = .noFilter
        filter.countries = ["IND"]
        
        GoogleMapManager.shared.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { result, error in
            
            guard let result = result, error == nil else { return completionHandler(.failure(GooglePlacesSearchError.noResult))  }
            
            completionHandler(.success(result.compactMap{SearchResultModel(placeID: $0.placeID, placeName: $0.attributedFullText.string)}))
        }
    }
    
    
    ///Get Coordinates from Place Name.
    func fetchCoordinates( for place:SearchResultModel,completionHandler: @escaping(Result<CLLocationCoordinate2D,Error>)->Void ){
        GoogleMapManager.shared.fetchPlace(fromPlaceID: place.placeID, placeFields: .coordinate, sessionToken: nil) { googlePlace, err in
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
        do{
            let geocodeResponse = try await gms.reverseGeocodeCoordinate(coordinate)
            return geocodeResponse.firstResult()?.lines?[0]
        }
        catch{
            print("error occurrred")
            return nil
        }
    }
}


class GeoCodingManager:GeocodingProtocol{
    
    let gms:GMSGeocoder
    init(gms:GMSGeocoder){
        self.gms = gms
    }
    ///GET **PLACE ADDRESS **from **COORDINATES**
    func getPlaceName(of coordinate: CLLocationCoordinate2D) async throws -> String? {
        do{
            let geocodeResponse = try await gms.reverseGeocodeCoordinate(coordinate)
            return geocodeResponse.firstResult()?.lines?[0]
        }
        catch{
            print("error occurrred")
            return nil
        }
    }
    
//    func getCoordinates(of place:CLLocation) async{
//        let de = CLGeocoder()
//        do{
//            let locations = CLLocation(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
//            try await de.reverseGeocodeLocation(<#T##location: CLLocation##CLLocation#>)
//        }
//        catch(let er){
//
//        }
//    }
}
