//
//  InfoView.swift
//  GoogleMaps-FoodDeliveryApp
//
//  Created by Harsh Yadav on 22/07/22.
//

import SwiftUI

struct InfoView: View {
    var instructions:[String]
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            List(instructions,id:\.self){ i in
                HStack{
                    Text("\(i)")
                }
            }
        }
        .navigationTitle("Instructions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(instructions: [])
    }
}
