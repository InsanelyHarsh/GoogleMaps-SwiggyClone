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
    
    @EnvironmentObject var directionMapVM:DirectionMapViewModel
    @EnvironmentObject var stateHandler:StateHandler
    @StateObject var directionLocationManager:DirectionLocationManager = DirectionLocationManager()
    
    var mapView:GMSMapView!
    
    var icon:((String,UIColor)->(UIImageView)) = { x,y in
        let icon = UIImageView(image: UIImage(systemName: x)?.withTintColor(.orange))
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30)
        ])
        icon.tintColor = y
        
        return icon
    }
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        self.stateHandler.makeCamera()
        let camera = self.stateHandler.currentState!
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.mapType = .normal
        
        
        mapView.delegate = context.coordinator
        
        mapView.isMyLocationEnabled = true        
        drawNavigationPath(mapView: mapView)

        
        let pick = GMSMarker(position: stateHandler.userPickupLocation!)
        pick.title = "Pickup Location"

        pick.iconView = self.icon("figure.walk", .systemPink)
        
        
        let drop = GMSMarker(position: stateHandler.userDropLocation!)
        drop.title = "Drop Location"
        
        drop.iconView = self.icon("mappin", .blue)
        
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
    func makeCoordinator() -> Coordinator {
        return Coordinator(state: $stateHandler.updatedState)
    }
    
    class Coordinator:NSObject,GMSMapViewDelegate{
        @Binding var state:GMSCameraPosition?
        init(state:Binding<GMSCameraPosition?>){
            self._state = state
        }


        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {

            print("MapView didChangeCameraPosition " + "\(position.target.longitude),\(position.target.latitude) " + "zoom: \(position.zoom) bearing: \(position.bearing)")
//            self.position = position
            self.state = position
            
        }
    }
}
