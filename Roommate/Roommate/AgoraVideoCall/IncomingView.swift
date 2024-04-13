//
//  IncomingView.swift
//  Roommate
//
//  Created by Spring2024 on 4/11/24.
//

import SwiftUI

struct IncomingView: View {
    @ObservedObject var agoraManager: AgoraManager = AgoraManager.shared
    var callerName: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                Text("Calling From")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                Text(callerName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                HStack(spacing: 120) {
                    Button(action: {
                        agoraManager.declineCall()
                    }) {
                        Image(systemName: "phone.down.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.red)
                            .background(Color.white)
                            .clipped()
                            .clipShape(
                                Circle()
                            )
                    }
                    Button(action: {
                        agoraManager.acceptCall()
                    }) {
                        Image(systemName: "phone.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.green)
                            .background(Color.white)
                            .clipped()
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    IncomingView(callerName: "Bob")
}
