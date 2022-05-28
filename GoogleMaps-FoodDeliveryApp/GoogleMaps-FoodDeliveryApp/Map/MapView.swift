//
//  MapView.swift
//  Dummy
//
//  Created by Harsh Yadav on 26/05/22.
//
import SwiftUI
import GoogleMaps
import CoreLocation

struct MapView: View {
    @Binding var coordinates:CLLocationCoordinate2D
    
    
    @StateObject var vm = MapViewModel()
    
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            
            GoogleMapsView(coordinate: $coordinates)
                .padding(.top,40).background{
                    Color.orange.brightness(1)
                }
            
            
            VStack(alignment: .leading){
                Text("Coordinates: \(coordinates.longitude), \(coordinates.latitude)")
                Text("Country: \(vm.placeName)")
            }
            .foregroundColor(.white)
            .padding(.bottom,13)
            .background{
                Rectangle()
                    .foregroundColor(.teal).opacity(0.9)
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width*(0.98), height: 130, alignment: .center)
            }
        }
        .onChange(of: coordinates, perform: { newValue in
            Task{
                await vm.getPlaceName(of: newValue)
            }
        })
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(coordinates: .constant(CLLocationCoordinate2D(latitude: 93, longitude: 23)))
//    }
//}
extension CLLocationCoordinate2D:Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
    
    
}
