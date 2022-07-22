//
//  DirectionSearchView.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 20/07/22.
//

import SwiftUI
import CoreLocation

struct DirectionSearchView: View {
    @StateObject var directionSearchVM:DirectionSearchViewModel = DirectionSearchViewModel(searchManager: SearchManager(),
                                                                                              locationManager: LocationManager())
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var searchLocation:String
    @Binding var searchLocationCoorinates:CLLocationCoordinate2D?
    
    @EnvironmentObject var stateHandler:StateHandler

    var didSelectCurrent:((Bool)-> Void)

        
    var body: some View {
        VStack{
            CustomTextField(txt: $directionSearchVM.query, initialText: "Search Location", keyBoardType: .default)
                .padding(.bottom,10)

            Button {
                Task{
                    await self.directionSearchVM.getCurrentLocation()
                    
                    self.searchLocationCoorinates = directionSearchVM.coordinate //Current Coorinates...
                    self.searchLocation = self.directionSearchVM.currentLocationName
                    didSelectCurrent(true)
                    dismiss()
                }
            } label: {
                HStack{
                    Image(systemName: "location.circle")
                    Text("Current Location")
                    
                    Spacer()
                }
                .tint(.gray)
                .padding(.horizontal)
            }
            
            
            
            List(directionSearchVM.seachResults,id:\.placeID){ i in
                Button {
                    self.directionSearchVM.isloading = true
                    self.searchLocation = i.placeName
                    
                    self.directionSearchVM.getCoordinates(for: i)
                    didSelectCurrent(false)
                } label: {
                    Text("\(i.placeName)")
                }
            }
            .listStyle(.inset)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: directionSearchVM.isloading, perform: { newValue in
            if !newValue{
                self.searchLocationCoorinates = directionSearchVM.coordinate //Place's Coorinates...
                dismiss()
            }
        })
        .onChange(of: directionSearchVM.query) { newValue in
            directionSearchVM.searchLocation()
        }
    }
}

//struct DirectionSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        DirectionSearchView(searchLocation: .constant(""),
//                            searchLocationCoorinates: .constant(CLLocationCoordinate2D(latitude: 43, longitude: 02)))
//    }
//}
