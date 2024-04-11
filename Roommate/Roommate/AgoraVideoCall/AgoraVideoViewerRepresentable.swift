//
//  VideoCallView.swift
//  Roommate
//
//  Created by Spring2024 on 4/10/24.
//

import SwiftUI
import AgoraUIKit


struct AgoraVideoViewerRepresentable: UIViewRepresentable {
    @ObservedObject var agoraManager: AgoraManager = AgoraManager.shared
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        let rtcToken = agoraManager.rtcToken
        let channelName = agoraManager.rtcChannelId
        
        let agoraView = AgoraVideoViewer(
            connectionData: AgoraConnectionData(appId: agoraManager.appId, rtcToken: rtcToken),
            style: .grid
        )
        agoraManager.agoraVideoViewer = agoraView
        agoraView.fills(view: view)
        agoraView.join(channel: channelName, as: .broadcaster)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}
