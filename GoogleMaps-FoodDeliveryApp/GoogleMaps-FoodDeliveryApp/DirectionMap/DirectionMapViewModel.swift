//
//  DirectionMapViewModel.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 20/07/22.
//

import Foundation
import CoreLocation
import GoogleMaps
import Combine

class DirectionMapViewModel:ObservableObject{

    @Published var directionResponseError:String = ""
    @Published var mapDirectionModel:MapDirectionModel? = nil
    
    let directionManager:DirectionManager = DirectionManager()
    let networking:NetworkingManager = NetworkingManager()
    
    func getDirections(source:CLLocationCoordinate2D,destination:CLLocationCoordinate2D) async{
        do{
            
            let urlString = "https://maps.googleapis.com/maps/api/directions/json?destination=\(destination.latitude),\(destination.longitude)&mode=driving&key=AIzaSyCE6d2-Dvki9iPBtaP6NRO9WQFnSR4M7XI&origin=\(source.latitude),\(source.longitude)"
            
            print(urlString)
            let directionResult = try await networking.getJSON(url: urlString, type: MapDirectionModel.self)
            
            await MainActor.run{
                self.mapDirectionModel = directionResult
            }
        }
        catch(let error){
            guard let er = error as? NetworkingError else { return }
            self.showError(errorType: er)
        }
    }
    
//    private func drawNavigationPath(mapView: GMSMapView){
//        Task{
//            await directionMapVM.getDirections(source: pickupLocation!, destination: dropLocation!)
//            logic(mapView: mapView)
//        }
//    }
    
    func getpolylines(data:MapDirectionModel?)->[GMSPolyline]{
        var polylines:[GMSPolyline] = []
        
        if let respnonse = data{
            
            if let routes = respnonse.routes{
                for route in routes {
                    
                    if let legs = route.legs{
                        for leg in legs {
                            
                            if let steps = leg.steps{
                                for step in steps {
                                    
                                    let path = GMSPath(fromEncodedPath: step.polyline!.points!)
                                    let polyline = GMSPolyline(path: path)
                                    
                                    polyline.strokeColor = .black
                                    
                                    polyline.strokeWidth = 3
                                    polylines.append(polyline)
//                                    polyline.map = mapView
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
        return polylines
    }
}

extension DirectionMapViewModel{
    private func showError(errorType: NetworkingError){
        Task{
            await MainActor.run{
                switch errorType {
                case .badURL:
                    self.directionResponseError = "Bad URL,contact Support Team."
                case .badResponse:
                    self.directionResponseError = "Bad Response"
                case .decodingFailed:
                    self.directionResponseError = "An Error Occured While Decoding"
                case .unknownError:
                    self.directionResponseError = "Unknown Error, Please try after some time."
                case .encodingFailed:
                    self.directionResponseError = "Something Went wrong while Encoding"
                }

            }
        }
    }
}
