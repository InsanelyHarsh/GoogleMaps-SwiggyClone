//
//  DirectionManager.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 18/07/22.
//

import Foundation
import GoogleMaps

class DirectionManager{
    func drawPath(from polyStr: String)->GMSPolyline{
        let path = GMSPath(fromEncodedPath: polyStr)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 10
        polyline.strokeColor = .red
        return polyline
//        polyline.map = mapView // Google MapView
    }}
