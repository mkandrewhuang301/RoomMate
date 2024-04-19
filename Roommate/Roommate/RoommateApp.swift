//
//  RoommateApp.swift
//  Roommate
//
//  Created by Spring2024 on 3/15/24.
//

import SwiftUI

@main
struct RoommateApp: App {
    @StateObject private var agoraManager = AgoraManager.shared
    @StateObject private var dataModel = Database.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willTerminateNotification)) { _ in
                    agoraManager.logoutRTM()
                    agoraManager.agoraVideoViewer?.leaveChannel()
                } // logout the video calling channel when exiting the app
        }
    }
}
