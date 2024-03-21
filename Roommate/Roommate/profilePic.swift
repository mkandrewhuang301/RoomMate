//
//  profilePic.swift
//  Roommate
//
//  Created by Andrew Huang on 3/20/24.
//

import SwiftUI

struct profilePic: View {
    var photo: String
    let height: Double
    let width: Double
    var body: some View {
        if let imageData = Data(base64Encoded: photo), let UIImage = UIImage(data: imageData){
            Image(uiImage: UIImage)
                .resizable()
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.gray, lineWidth:4)
                }
                .shadow(radius:10)
                .frame(width: width, height: height)
        }
        else{
            Image("avatar")
                .resizable()
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.gray, lineWidth:4)
                }
                .shadow(radius:10)
                .frame(width: width, height: height)
            
        }
    }
}

/*
 #Preview {
 profilePic()
 }
 */
