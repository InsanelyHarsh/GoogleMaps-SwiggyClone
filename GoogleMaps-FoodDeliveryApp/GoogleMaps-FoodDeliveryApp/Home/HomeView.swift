//
//  HomeView.swift
//  Dummy
//
//  Created by Harsh Yadav on 26/05/22.
//
import SwiftUI
import CoreLocation
struct HomeView: View {
    
//    @EnvironmentObject var vm:LocationManager
    @StateObject var vm = LocationManager()
//    @StateObject var homeVM = HomeViewModel(locationManager: LocationManager())
    @Environment(\.openURL) var openURL
    @State var noPermission:Bool = true
    
    var body: some View {
//        NavigationView{
            VStack{
                HStack{
                    NavigationLink {
                        SearchView()
                    } label: {
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "location.fill")
                                Text("Location")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            }
                            
//                                Text("B Block, Sector 59, Noida, Utter Pradesh")
                            Text("\(vm.userLocation)")
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
                
                //TODO: improve.....
//                Text("\(vm.latitude),\(vm.longitude)")
//                Text("\(vm.locationStatus)")
                
                
                //TODO: Cleaning/Refactoring
                switch vm.locationStatus{
                case .unknown:
                    Text("Ahh... Location permission Status is unknown.")
                    
                case .auth:
                    Text("Thanks for giving Permission.🤝")
                    
                    switch vm.accuracyStatus{
                    case .unknown:
                        Text("Accuracy Status is Unknown. 🤨")
                    case .reduced:
                        Text("Your are one step from Great Experience.")
                        Text("⚠️ Provide Precise Location. ⚠️")
                    case .full:
                        Text("All Set")
                    }
                    
                case .notAuth:
                    Text("Please Provide Location Permission for Better Experience.")

                case .denied:
                    Text("Please Do not Deny Location Permission 🥺.")
                }
                
                
                switch vm.locationStatus{
                case .unknown,.denied,.notAuth:
                    Button {
                        openURL(URL(string: UIApplication.openSettingsURLString)!)
                    } label: {
                        Text("Give permission")
                    }
                case .auth:
                    switch vm.accuracyStatus{
                    case .unknown,.reduced:
                        Button {
                            openURL(URL(string: UIApplication.openSettingsURLString)!)
                        } label: {
                            Text("Give permission")
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background{
                            Color.red.cornerRadius(5)
                        }
                        
                    case .full:
                        Button {
                            vm.updateLocation()
                        } label: {
                            HStack{
                                Image(systemName: "location.fill")
                                Text("Update User Location")
                            }
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background{
                            Color.blue.cornerRadius(5)
                        }
                    }
                }
                
                Spacer()
            }
            
//            .navigationTitle("Foodie")
//        }
    }
    
    func ok(){
        self.noPermission = true
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

