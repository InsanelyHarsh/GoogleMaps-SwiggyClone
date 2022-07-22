//
//  DirectionMapView.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 20/07/22.
//

import SwiftUI
import CoreLocation

struct DirectionMapView: View {
//    @Binding var pickupCoordintes:CLLocationCoordinate2D?
//    @Binding var dropCoordintes:CLLocationCoordinate2D?
        
    @Environment(\.dismiss) private var dismiss

    @StateObject var directionMapVM = DirectionMapViewModel()
    
    @EnvironmentObject var stateHandler:StateHandler
    
    @State var newCoorinates:CLLocationCoordinate2D?{
        willSet{
            
        }
    }
    var body: some View {
        
        ZStack(alignment: .bottom){
            
//            DirectionMapViewController(dropLocation: $dropCoordintes, pickupLocation: $pickupCoordintes)
            DirectionMapViewController()
                .environmentObject(directionMapVM)
                .environmentObject(stateHandler)
                .navigationTitle("Map")
                .navigationViewStyle(.stack)
            
            
            HStack{
                VStack(alignment: .leading,spacing: 5){
                    Text("Estimated Time: \(directionMapVM.mapDirectionModel?.routes?[0].legs?[0].duration?.text ?? "-")")
                    
                    Text("Distance: \(directionMapVM.mapDirectionModel?.routes?[0].legs?[0].distance?.text ?? "-")")
                    
                    Text("Arrival Time: \(directionMapVM.mapDirectionModel?.routes?[0].legs?[0].arrivalTime?.text ?? "-")")
                    
                    Text("Departure Time: \(directionMapVM.mapDirectionModel?.routes?[0].legs?[0].departureTime?.text ?? "-")")
                    
                    Text("Selected Current Location : \((stateHandler.didSelectCurrentPickLocation || stateHandler.didSelectionCurrentDropLocation) ? "Yes" : "No")")
                }
                .padding(.leading)
                .foregroundColor(.white)
                .padding(.bottom)
                Spacer()
            }
            .background{Color.black.cornerRadius(10).opacity(0.4)}
            .padding(.top)
            .cornerRadius(10)
        }
        .task {
            Task{
                await directionMapVM.getDirections(source: stateHandler.userPickupLocation!, destination: stateHandler.userDropLocation!)
                let z = self.directionMapVM.getpolylines(data: self.directionMapVM.mapDirectionModel)
                for i in z{
//                    i.map = mapView
                }
            }
        }
    }
}

//struct DirectionMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        DirectionMapView(coordinates: .constant(CLLocationCoordinate2D(latitude: 3, longitude: 3)))
//    }
//}
