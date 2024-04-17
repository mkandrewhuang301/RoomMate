//
//  ChatRow.swift
//  Roommate
//
//  Created by Spring2024 on 4/9/24.
//

import SwiftUI

struct ChatRow: View { // this is one row of friend showing photo name and calling button
    @Binding var user: User
    @ObservedObject var agoraManager: AgoraManager = AgoraManager.shared
    
    var body: some View {
        ZStack {
            HStack (spacing: 20){
                if let imageData = Data(base64Encoded: user.photos[0]), let UIImage = UIImage(data: imageData) {
                    Image(uiImage: UIImage)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 70, height: 70)
                }
                Text("\(user.fName) \(user.lName)")
                    .font(.custom("HelveticaNeue", size: 18))
                    .fontWeight(.heavy)
                    .frame(width: 180, alignment: .leading)
                    .padding(.bottom, 40)
                Spacer()
            }
            HStack {
                Spacer()
                Button(action: {
                    agoraManager.sendCallRequest(targetUser: user.id.uuidString) { result in
                        if result {
                            print("Call request sent")
                        } else {
                            
                        }
                    }
                }) {
                    Image(systemName: "phone.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(.vertical)
    }
}

//#Preview {
//    ChatRow()
//}
