//
//  EditPhotoView.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

// this is the comonent showing the photos in the profile editing
// page
struct EditPhotoItem: View {
    @Binding var imageStr: String

    var body: some View {
        ZStack {
            ZStack {
                if let imageData = Data(base64Encoded: imageStr), let UIImage = UIImage(data: imageData){
                    Image(uiImage: UIImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 233/255, green: 234/255, blue: 238/255))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(style: StrokeStyle(lineWidth: 7, dash: [12]))
                                .foregroundColor(Color(red: 185/255, green: 191/255, blue: 200/255))
                        )
                    
                    Image(systemName: "plus.circle")
                        .font(.largeTitle)
                        .foregroundColor(Color.accentColor)
                }
            }
            .frame(width: 130, height: 200)
            .cornerRadius(8)
            if let imageData = Data(base64Encoded: imageStr), let _ = UIImage(data: imageData){
                Color(red: 0.95, green: 0.95, blue: 0.95)
                    .frame(width:34, height:34)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .offset(x:55, y: 95)
                Image(systemName:"pencil.circle")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width:34, height:34)
                    .offset(x:55, y: 95)
            }
        }
    }
}
//
//#Preview {
//    EditPhotoItem(imageStr: "hi")
//}
