    //
    //  HomeView.swift
    //  Dummy
    //
    //  Created by Harsh Yadav on 26/05/22.
    //

    import SwiftUI

    struct HomeView: View {
        @ObservedObject var vm = LocationManager()
        var body: some View {
            NavigationView{
                VStack{
                    HStack{
                        NavigationLink {
                            SearchView()
                        } label: {
                            VStack(alignment: .leading){
                                HStack{
                                    Image(systemName: "location.fill")
                                    Text("B10")
                                        .font(.title2)
                                        .foregroundColor(.black)
                                }
                                
                                Text("B Block, Sector 59, Noida, Utter Pradesh")
                                    .lineLimit(1)
                                    .foregroundColor(.gray)
                            }
                        }

                        Spacer()
                        
                        Image(systemName: "person.fill")
                            .foregroundColor(.orange)
                            .background{
                                Circle()
                                    .frame(width: 35, height: 35, alignment: .center)
                            }
                        
                    }
                    .padding()
                    .background{
                        Color.pink.opacity(0.3).brightness(0.6)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Text("\(vm.latitude),\(vm.longitude)")
                    Text("\(vm.locationStatus)")
                    
                   
                    Button {
                        vm.updateLocation()
                    } label: {
                        Text("Update User Location")
                    }

                    Spacer()
                }
                
                .navigationTitle("Foodie")
            }
        }
    }

    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }

