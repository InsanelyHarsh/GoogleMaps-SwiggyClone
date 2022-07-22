//
//  DirectionsView.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 18/07/22.
//

import SwiftUI
import CoreLocation
class DirectionRoutingManager:ObservableObject{
    @Published var showSearchView:Bool = false
    @Published var showDropLocation:Bool = false
    @Published var showPickupLocation:Bool = false
}


struct DirectionsView: View {
    @State var dropLocation:String = ""
    @State var pickUpLocation:String = ""
    @StateObject var routingManager:DirectionRoutingManager = DirectionRoutingManager()
    
//    @State var pickupLocationCoordintes:CLLocationCoordinate2D?
//    @State var dropLocationCoorinates:CLLocationCoordinate2D?
    
    @State var showDirectionMap:Bool = false
    
    @EnvironmentObject var stateHandler:StateHandler
    var body: some View {
//        NavigationView{
            VStack{
                
                RoundedRectangle(cornerRadius: 7)
                    .stroke(lineWidth: 1)
                    .frame(height: 50, alignment: .center)
                    .padding(.horizontal)
                    .opacity(0.4)
                    .background{
                        HStack{
                            Text(pickUpLocation.isEmpty ? "Pick up Location" : pickUpLocation)
                                .foregroundColor(.gray)
                                .padding(.leading,27)
                                .padding(.trailing,10)
                            Spacer()
                        }
                    }
                    .onTapGesture {
                        self.routingManager.showPickupLocation = true
                    }
                    .padding(.bottom)

                RoundedRectangle(cornerRadius: 7)
                    .stroke(lineWidth: 1)
                    .frame(height: 50, alignment: .center)
                    .padding(.horizontal)
                    .opacity(0.4)
                    .background{
                        HStack{
                            Text(dropLocation.isEmpty ? "Drop Location" : dropLocation)
                                .foregroundColor(.gray)
                                .padding(.leading,27)
                                .padding(.trailing,10)
                            Spacer()
                        }
                    }
                    .onTapGesture {
                        self.routingManager.showDropLocation = true
                    }
                    .padding(.bottom)

                //TODO: $pickupLocationCoordintes       $dropLocationCoorinates
                
                NavigationLink(isActive: $routingManager.showPickupLocation) {
                    DirectionSearchView(searchLocation: $pickUpLocation, searchLocationCoorinates: $stateHandler.userPickupLocation, didSelectCurrent: { x in
                        self.stateHandler.didSelectCurrentPickLocation = x
                    })
                        .environmentObject(stateHandler)
                        .navigationViewStyle(.stack)
                } label: {
                    EmptyView()
                }
                
                
                NavigationLink(isActive: $routingManager.showDropLocation) {
                    DirectionSearchView(searchLocation: $dropLocation, searchLocationCoorinates: $stateHandler.userDropLocation, didSelectCurrent: {  x in
                        self.stateHandler.didSelectionCurrentDropLocation = x
                    })
                        .environmentObject(stateHandler)
                        .navigationViewStyle(.stack)
                } label: {
                    EmptyView()
                }

                
                NavigationLink(isActive: $showDirectionMap){
//                    DirectionMapView(pickupCoordintes: $stateHandler.userPickupLocation,
//                                     dropCoordintes: $stateHandler.userDropLocation)
                    DirectionMapView()
                    .environmentObject(stateHandler)
                    .navigationViewStyle(.stack)
                    
                } label: {
                    Button {
                        if ((stateHandler.userDropLocation != nil) && (stateHandler.userPickupLocation != nil)){
                            
                            self.stateHandler.updatedPickupLocation = stateHandler.userPickupLocation
                            self.stateHandler.userDropLocation = stateHandler.userDropLocation
                            
                            self.stateHandler.updatedPickupLocation = stateHandler.updatedPickupLocation
                            self.stateHandler.userDropLocation = stateHandler.userDropLocation
                            self.showDirectionMap.toggle()
                        }
                    } label: {
                        Text("Get Direction 🚀")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .background{ Color.blue.cornerRadius(10)
                            }
                    }
                }
                
                
                Spacer()

            }
//            .navigationTitle("Directions")
//            .navigationBarTitleDisplayMode(.inline)
//        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView()
    }
}
