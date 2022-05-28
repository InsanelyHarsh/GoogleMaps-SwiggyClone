    //
    //  SearchView.swift
    //  Dummy
    //
    //  Created by Harsh Yadav on 26/05/22.
    //

    import SwiftUI
    import CoreLocation

    struct SearchView: View {
        
        @StateObject var vm = SearchViewModel()
        @State var isPressed:Bool = false
        
        var body: some View {
            VStack{
//                Text("\(vm.coordinate.longitude), \(vm.coordinate.latitude)")
                
                TextField("Search for area,street name...", text: $vm.query)
                    .padding()
                    .background{
                        Color.gray.opacity(0.3).cornerRadius(5)
                    }
                    .padding(.horizontal)
                
                List{
                    ForEach(vm.placeResult,id:\.placeID) { i in

                        Button {
                            vm.getCoordinates(for: i)
                            isPressed.toggle()
                        } label: {
    //                        CustomCell(place: i.placeName)
                            Text("\(i.placeName)")
                        }
                        .sheet(isPresented: $isPressed) {
                            isPressed = false
                        } content: {
                            MapView(coordinates: $vm.coordinate)
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



