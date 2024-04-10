//
//  NewMatchItem.swift
//  Roommate
//
//  Created by Spring2024 on 4/10/24.
//

import SwiftUI

struct NewMatchItem: View {
    @Binding var user: User
    @Binding var friend: User
    @StateObject var uploadViewModel = UploadViewModel()
    
    var body: some View {
        ZStack {
            if let imageData = Data(base64Encoded: friend.photos[0]), let UIImage = UIImage(data: imageData) {
                Image(uiImage: UIImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 150)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            Button(action: {
                let jsonObject = [
                    "myid": user.id.uuidString,
                    "matchid": friend.id.uuidString
                ]
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
                    if !uploadViewModel.upload(website: "http://vcm-39030.vm.duke.edu:8080/roommate/apply", json: jsonData) {
                        print("Failed to start upload task")
                        return
                    }
                }
                user.friends.append(friend.id)
                user.waitList.removeAll { $0 == friend.id }
            }) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .background(.white)
                    .clipped()
                    .clipShape(Circle())

            }
            .offset(x: 55, y: -65)
            
            Button(action: {
                let jsonObject: [String: Any] = [
                    "myid": user.id.uuidString,
                    "matchid": friend.id.uuidString
                ]
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
                    if !uploadViewModel.upload(website: "http://vcm-39030.vm.duke.edu:8080/roommate/reject", json: jsonData) {
                        print("Failed to start upload task")
                        return
                    }
                }
                user.waitList.removeAll { $0 == friend.id }
            }) {
               Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    .background(.white)
                    .clipped()
                    .clipShape(Circle())
                    .foregroundColor(.red)

            }
            .offset(x: 55, y: 65)
        }
        .padding(.vertical)
    }
}

//#Preview {
//    NewMatchItem()
//}
