//
//  MapViewController.swift
//  Dummy
//
//  Created by Harsh Yadav on 26/05/22.
//

import GoogleMaps
import UIKit
import SwiftUI

//MARK: UIKIT
struct GoogleMapsView: UIViewRepresentable {
    
    private let zoom: Float = 20
    @Binding var coordinate:CLLocationCoordinate2D
    let customMarker:UIImageView = {
        let img = UIImageView(frame: .zero)
        img.image = UIImage(systemName: "circle.circle.fill")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image?.withTintColor(.systemPink)
        return img
    }()
    
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 3)
        
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.mapType = .normal
        
        layout(mapView:mapView) //custom marker
        
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        
        return mapView
    }
    
        //SWIFTUI ---> UIKIT
        //UPDATING UIKIT FROM CHANGING SWIFTUI
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
        let upd = GMSCameraUpdate.setTarget(coordinate)
        mapView.animate(with: upd)
    }
    
        
    
        //UIKIT ---> SWIFTUI
        //UPDATING SWIFTUI FROM CHANGING UIKIT
    func makeCoordinator() -> Coordinator {
        return Coordinator(centerCoodinates: $coordinate)
    }
    
    
    
    class Coordinator:NSObject,GMSMapViewDelegate{
    
        @Binding var centerCoodinates:CLLocationCoordinate2D

        var position:GMSCameraPosition?{
            didSet{
                print("Position Changed")
            }
        }
        init(centerCoodinates:Binding<CLLocationCoordinate2D>){
            self._centerCoodinates = centerCoodinates
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
          
            print("MapView didChangeCameraPosition " + "\(position.target.longitude),\(position.target.latitude) " + "zoom: \(position.zoom) bearing: \(position.bearing)")
            
            self.position = position
         }
        
        func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
            
            guard let position = position else {
                return
            }
            
            mapView.animate(toLocation: position.target)
            self.centerCoodinates = position.target
            
        }
        
    }

    

    private func layout(mapView:GMSMapView){
        mapView.addSubview(customMarker)
        NSLayoutConstraint.activate([
            customMarker.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            customMarker.centerYAnchor.constraint(equalTo: mapView.centerYAnchor)
        ])
    }
}











class GoogleMapViewController:UIViewController{
    
    private let zoom: Float = 20
    
    let camerPosition:GMSCameraPosition
    let mapView:GMSMapView
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.camerPosition =  GMSCameraPosition.camera(withLatitude: 28.6031121, longitude: 77.3668853, zoom: 10)
        self.mapView = GMSMapView.map(withFrame: .zero, camera: camerPosition)
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setup()
    }
    
    private func setup(){
        
    }
    
    private func layout(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.frame = self.view.frame
    }
    
    private func update(){
            //        let update = GMSCameraUpdate.setCamera(GMSCameraPosition(latitude: 51.5072, longitude: 0.1276, zoom: 6))
            //        mapView.animate(toLocation: CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>))
        
        
    }
}
