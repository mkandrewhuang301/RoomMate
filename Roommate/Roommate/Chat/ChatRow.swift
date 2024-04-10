//
//  ChatRow.swift
//  Roommate
//
//  Created by Spring2024 on 4/9/24.
//

import SwiftUI

struct ChatRow: View {
    @Binding var user: User
    
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
//                    .border(Color.black)
                Spacer()
            }
            HStack {
                Spacer()
                Button(action: {
                    print("Button pressed")
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
