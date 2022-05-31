//
//  SearchView.swift
//  Dummy
//
//  Created by Harsh Yadav on 26/05/22.
//

import SwiftUI
import CoreLocation
import GoogleMaps
struct SearchView: View {

    @StateObject var vm = SearchViewModel(manager: GoogleMapManager(gms: GMSGeocoder()),locationManager: LocationManager())
    @State var isPressed:Bool = false
    @State var isConfirm:Bool = false
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        VStack{
            TextField("Search for area,street name...", text: $vm.query)
                .padding()
                .background{
                    Color.gray.opacity(0.3).cornerRadius(5)
                }
                .padding(.horizontal)
                .padding(.bottom,5)
            
            Button {
                vm.getCurrentLocation()
                isPressed.toggle()
            } label: {
                HStack{
                    Image(systemName: "location.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .foregroundColor(.blue)
                    
                    Text("Current Location")
                        .foregroundColor(.black)
                    
                    Spacer()
                }.padding(.leading,20)
                    .padding(.bottom,10)
            }
//            .disabled(locati)
            .sheet(isPresented: $isPressed) {
                if isConfirm{
                    dismiss()
                }
            } content: {
                MapView(coordinates: $vm.coordinate,isConfirm: $isConfirm)
            }

            
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(vm.placeResult,id:\.placeID) { i in
                    Button {
                        vm.getCoordinates(for: i)
                        isPressed.toggle()
                    } label: {
                        CustomCell(place: i.placeName)
                    }
                    .sheet(isPresented: $isPressed) {
                        if isConfirm{
                            dismiss()
                        }
                    } content: {
                        MapView(coordinates: $vm.coordinate,isConfirm: $isConfirm)
                    }
                }
            }
            
            
            Spacer()
        }
        .onChange(of: vm.query) { newValue in
            vm.getData()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}



