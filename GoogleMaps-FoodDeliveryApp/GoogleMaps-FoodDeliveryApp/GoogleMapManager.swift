//
//  MapManager.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 27/05/22.
//

import GooglePlaces
import GoogleMaps
//import GoogleNavigation

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
//class GoogleMapManager:GeocodingProtocol{
//        
//    let gms:GMSGeocoder
//    init(gms:GMSGeocoder){
//        self.gms = gms
//    }
//    
//    ///Gives Place Name from Coordinates. This is async function.
//    func getPlaceName(of coordinate:CLLocationCoordinate2D) async throws -> String?{
//        do{
//            let geocodeResponse = try await gms.reverseGeocodeCoordinate(coordinate)
//            return geocodeResponse.firstResult()?.lines?[0]
//        }
//        catch{
//            print("error occurrred")
//            return nil
//        }
//    }
//}


enum GeoCodingError:Error{
    case geoCodingFailed
}
class GeoCodingManager:GeocodingProtocol{
    
    let geoCoder:GMSGeocoder
    init(geoCoder:GMSGeocoder){
        self.geoCoder = geoCoder
    }
    ///GET **PLACE ADDRESS **from **COORDINATES**
    func getPlaceName(of coordinate: CLLocationCoordinate2D) async throws -> String? {
        do{
            let geocodeResponse = try await geoCoder.reverseGeocodeCoordinate(coordinate)
            return geocodeResponse.firstResult()?.lines?[0]
        }
        catch{
//            print("error occurrred")
//            return nil
            throw GeoCodingError.geoCodingFailed
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
