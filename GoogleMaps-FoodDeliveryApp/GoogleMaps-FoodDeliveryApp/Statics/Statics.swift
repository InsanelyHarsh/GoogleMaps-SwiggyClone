//
//  Statics.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 18/07/22.
//

import Foundation
struct Statics{
    /// outputFormat ---> json/xml
    static let baseURLFormat:String = "https://maps.googleapis.com/maps/api/directions/outputFormat?parameters"
//    "https://maps.googleapis.com/maps/api/directions/outputFormat?parameters"
//    http://maps.googleapis.com/maps/api/directions/json?origin=83,2&destination=84,18&sensor=false&mode=driving
    //https://maps.googleapis.com/maps/api/directions/json?destination=Delhi&mode=transit&key=AIzaSyCE6d2-Dvki9iPBtaP6NRO9WQFnSR4M7XI&origin=Jaipur
    //https://maps.googleapis.com/maps/api/directions/json?destination=3,4&mode=transit&key=AIzaSyCE6d2-Dvki9iPBtaP6NRO9WQFnSR4M7XI&origin=49,2
    static let directionAPI:String = "AIzaSyCE6d2-Dvki9iPBtaP6NRO9WQFnSR4M7XI"
    
    
    
}
//Required parameters:
/*
 destination
 origin
 */

/*
 alternatives
 arrival_time
 avoid
 departure_time
 language
 mode
 region
 traffic_model
 */


//End Point types:
/*
 https://maps.googleapis.com/maps/api/directions/json? destination=Montreal & origin=Toronto & key=YOUR_API_KEY
 
 https://maps.googleapis.com/maps/api/directions/json ? avoid=highways & destination=Montreal & mode=bicycling & origin=Toronto & key=YOUR_API_KEY
 
 
 */
