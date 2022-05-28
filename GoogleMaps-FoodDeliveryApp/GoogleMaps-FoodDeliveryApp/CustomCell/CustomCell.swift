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
            HStack{
                Text(place)
            }
            .frame(width: UIScreen.main.bounds.width*(0.90))
            .padding()
            .background{
                Color.gray.opacity(0.3).cornerRadius(8)
            }
        }
    }

    struct CustomCell_Previews: PreviewProvider {
        static var previews: some View {
            CustomCell(place: "")
        }
    }
