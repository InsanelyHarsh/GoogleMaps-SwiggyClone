//
//  GoogleMaps_FoodDeliveryAppApp.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 27/05/22.
//


import SwiftUI
import GoogleMaps
import GooglePlaces
let APIKey = "AIzaSyAhR0HtGDcfzzU4aDLnAcncebqVZBt6oCs"

@main
struct GoogleMaps_FoodDeliveryAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate    {
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         GMSServices.provideAPIKey(APIKey)
         GMSPlacesClient.provideAPIKey(APIKey)
         return true
     }
 }
