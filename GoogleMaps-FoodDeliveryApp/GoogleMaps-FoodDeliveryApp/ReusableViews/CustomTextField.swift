//
//  CustomTextField.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 20/07/22.
//

import SwiftUI
//import UIKit
struct CustomTextField: View {
    
    @Binding var txt:String
    var initialText:String = "Enter Info"
    var keyBoardType:UIKeyboardType = .default
    
    var body: some View {
        VStack{
            TextField(initialText, text: $txt)
                .keyboardType(keyBoardType)
//                .font(Font(uiFont: UIFont(name: "SFProDisplay-Regular", size: 16) ?? .boldSystemFont(ofSize: 16)))
                .padding(.leading)
                .frame(width: 328, height: 56, alignment: .center)
                .background{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke()
                        .foregroundColor(Color(uiColor: UIColor(red: 0.882, green: 0.89, blue: 0.902, alpha: 1)))
                }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(txt: .constant(""))
    }
}
