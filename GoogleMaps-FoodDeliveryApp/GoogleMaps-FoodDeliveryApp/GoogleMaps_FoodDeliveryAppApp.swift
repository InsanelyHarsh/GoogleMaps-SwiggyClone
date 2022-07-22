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
    
    @State var selection:Int = 0
    
    @StateObject var stateHandler:StateHandler = StateHandler() //Saves Map's config, used when map is re-renderd every time location(current) is changed
    var body: some Scene {
        WindowGroup {
            NavigationView{
                TabView(selection: $selection) {
                    HomeView()
//                        .environmentObject(stateHandler)
                        .tag(0)
                        .tabItem {
                            VStack{
                                Image(systemName: selection == 0 ? "house.fill" : "house")
                                    .foregroundColor(.orange)
                                Text("User")
                            }
                        }
                    
                    DirectionsView()
                        .environmentObject(stateHandler)
                        .tag(1)
                        .tabItem {
                            VStack{
                                Image(systemName: selection == 1 ? "location.fill" : "location")
                                Text("Directions")
                            }.tint(.orange)
                        }
                }
                .environmentObject(stateHandler)
                .navigationTitle(selection == 0 ? "Home" : "Directions")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GMSServices.provideAPIKey(APIKey)
        GMSPlacesClient.provideAPIKey(APIKey)
        
        return true
    }
}
