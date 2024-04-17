//
//  CallingView.swift
//  Roommate
//
//  Created by Spring2024 on 4/11/24.
//

import SwiftUI

struct CallingView: View { // this is the view when you're calling someone
    @ObservedObject var agoraManager: AgoraManager = AgoraManager.shared
    var calleeName: String
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                    .frame(height: 100)
                Text("Calling...")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                Text(calleeName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    agoraManager.endCall()
                    withAnimation(.easeInOut(duration: 0.5)) {
                        agoraManager.showCallingView = false
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                        .background(Color.white)
                        .clipped()
                        .clipShape(Circle())
                        .padding()
                }
            }
        }
    }
}


#Preview {
    CallingView(calleeName: "Alice")
}
