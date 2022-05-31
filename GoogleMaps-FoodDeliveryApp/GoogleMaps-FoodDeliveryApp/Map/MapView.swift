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
    @Binding var isConfirm:Bool
    
    @Environment(\.dismiss) private var dismiss

    @StateObject var vm = MapViewModel()
    
    @EnvironmentObject var locationManager:LocationManager
    var body: some View {
        
        ZStack(alignment: .bottom){
            
            GoogleMapsView(coordinate: $coordinates)
                .padding(.top,40).background{
                    Color.orange.brightness(1)
                }
            
            
            VStack{
                VStack(alignment: .leading){
//                    Text("Coordinates: \(coordinates.longitude), \(coordinates.latitude)")
//                    Text("Address: \(vm.placeName)")
                    Text(vm.placeName)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .padding(.horizontal,3)
                }
                
                HStack{
                    Button {
                        coordinates = CLLocationCoordinate2D(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    } label: {
                        Text("Current Location")
                            .padding()
                            .foregroundColor(.white)
                            .background{
                                Color.orange.cornerRadius(5)
                            }
                    }
                    
                    
                    Button {
                        dismiss()
                        isConfirm = true
                    } label: {
                        Text("Confirm Location")
                            .padding()
                            .foregroundColor(.white)
                            .background{
                                Color.black.cornerRadius(5)
                            }
                    }
                }

            }
            .foregroundColor(.white)
            .padding(.bottom,13)
            .background{
                Rectangle()
                    .foregroundColor(.teal).opacity(0.9)
                    .cornerRadius(10)
                    .frame(width: UIScreen.main.bounds.width*(0.98), height: 170, alignment: .center)
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
