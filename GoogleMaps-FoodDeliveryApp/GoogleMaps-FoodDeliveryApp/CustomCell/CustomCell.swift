//
//  CustomCell.swift
//  Dummy
//
//  Created by Harsh Yadav on 26/05/22.
//

import SwiftUI

struct CustomCell: View {
    
    var place:String
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.gray)
                
                Text(place)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                    .lineLimit(2)
            }.padding(.bottom,3)
            
            Divider().foregroundColor(.black).padding(.horizontal,5)
        }
        .frame(width: UIScreen.main.bounds.width*(0.90))
    }
}

struct CustomCell_Previews: PreviewProvider {
    static var previews: some View {
        CustomCell(place: "")
    }
}
