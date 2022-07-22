//
//  DirectionMapViewController.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 20/07/22.
//

import Foundation
import CoreLocation
import UIKit
import SwiftUI
import GoogleMaps


class previousState:ObservableObject{
    @Published var cameraPosition:GMSCameraPosition?
    @Published var dropCoordinates:CLLocationCoordinate2D?
    @Published var pickupCoordinates:CLLocationCoordinate2D?
}
//MARK: UIKIT
struct DirectionMapViewController: UIViewRepresentable {
    private let zoom: Float = 20

//    @Binding var dropLocation:CLLocationCoordinate2D?
//    @Binding var pickupLocation:CLLocationCoordinate2D?
    
    @EnvironmentObject var directionMapVM:DirectionMapViewModel
    @EnvironmentObject var stateHandler:StateHandler
    @StateObject var directionLocationManager:DirectionLocationManager = DirectionLocationManager()
    
//    var curState:(()->GMSCameraPosition)

    var mapView:GMSMapView!
    
//    @Binding var cameraPosition:GMSCameraPosition
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        
//        let camera = GMSCameraPosition.camera(withLatitude: pickupLocation!.latitude, longitude: pickupLocation!.longitude, zoom: 15)
        let camera = GMSCameraPosition.camera(withLatitude: stateHandler.userPickupLocation!.latitude, longitude: stateHandler.userPickupLocation!.longitude, zoom: 15)
        
//        let camera = self.stateHandler.currentState
//        self.currentState(camera)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.mapType = .normal
        
//        layout(mapView:mapView) //custom marker
        
//        mapView.delegate = context.coordinator
        
        mapView.isMyLocationEnabled = true
//        directionLocationManager.startUpdating()
        
        drawNavigationPath(mapView: mapView)

        
        let pick = GMSMarker(position: stateHandler.userPickupLocation!)
        pick.title = "Pickup Location"
        pick.icon = UIImage(systemName: "airplane.departure")
        pick.icon?.withTintColor(.orange)
        
        
        let drop = GMSMarker(position: stateHandler.userDropLocation!)
        drop.title = "Drop Location"
        drop.icon = UIImage(systemName: "airplane.arrival")
        drop.icon?.withTintColor(.orange)
        
        pick.map = mapView
        drop.map = mapView
        return mapView
    }
    
    private func drawNavigationPath(mapView: GMSMapView){
        Task{
            await directionMapVM.getDirections(source: stateHandler.userPickupLocation!, destination: stateHandler.userDropLocation!)
            let z = self.directionMapVM.getpolylines(data: self.directionMapVM.mapDirectionModel)
            for i in z{
                i.map = mapView
            }
        }
    }

    
    //SWIFTUI ---> UIKIT
    //UPDATING UIKIT FROM CHANGING SWIFTUI
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
//        let upd = GMSCameraUpdate.setCamera(GMSCameraPosition(target: pickupLocation!, zoom: 17))
//        mapView.animate(with: upd)
//        mapView.center = mapView.center
            
    }
    
    
    //UIKIT ---> SWIFTUI
    //UPDATING SWIFTUI FROM CHANGING UIKIT
//    func makeCoordinator() -> Coordinator {
//        return Coordinator()
//    }
    
//    class Coordinator:NSObject,GMSMapViewDelegate{
//        var position:GMSCameraPosition?{
//            didSet{
//                print("Position Changed")
//            }
//        }
//
//
//        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//
//            print("MapView didChangeCameraPosition " + "\(position.target.longitude),\(position.target.latitude) " + "zoom: \(position.zoom) bearing: \(position.bearing)")
//
//
//            self.position = position
//        }
//
////        func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
////
////            guard let position = position else {
////                return
////            }
////
////            mapView.animate(toLocation: position.target)
//////            self.centerCoodinates = position.target
////                //            self.cameraPosition!(position)
////        }
//    }
}
