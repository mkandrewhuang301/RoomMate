//
//  VideoCallView.swift
//  Roommate
//
//  Created by Spring2024 on 4/12/24.
//

import SwiftUI

struct VideoCallView: View { // add hang up button based on AgoraVideoViewerRepresentable
    @ObservedObject var agoraManager: AgoraManager = AgoraManager.shared
    
    var body: some View {
        VStack {
            AgoraVideoViewerRepresentable()
            Button(action: {
                agoraManager.endCall()
                agoraManager.agoraVideoViewer?.leaveChannel()
                withAnimation(.easeInOut(duration: 0.5)) {
                    agoraManager.showVideoView = false
                }
            }) {
                Image(systemName: "phone.down.circle.fill")
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

#Preview {
    VideoCallView()
}
