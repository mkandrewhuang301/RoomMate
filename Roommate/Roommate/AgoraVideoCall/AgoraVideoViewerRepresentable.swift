//
//  VideoCallView.swift
//  Roommate
//
//  Created by Spring2024 on 4/10/24.
//

import SwiftUI
import AgoraUIKit

// this is the view for video calling provided by agoraUIkit, here what I've done
// is to merge that UIKit View in the Swift UI with UIViewRepresentable
struct AgoraVideoViewerRepresentable: UIViewRepresentable { /
    @ObservedObject var agoraManager: AgoraManager = AgoraManager.shared
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let rtcToken = agoraManager.currentRtcToken
        let channelName = agoraManager.currentRtcChannelId
        
        let agoraView = AgoraVideoViewer(
            connectionData: AgoraConnectionData(appId: agoraManager.appId, rtcToken: rtcToken)
        )
        agoraManager.agoraVideoViewer = agoraView
        agoraView.fills(view: view)
        print("rtctoken: \(rtcToken)")
        print("Joining channel: \(channelName)")
        let result = agoraView.join(channel: channelName, with: rtcToken, as: .broadcaster, uid: Optional(0))
        print("Joining channel result: \(String(describing: result))")
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}

