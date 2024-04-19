import AgoraRtcKit
import AgoraRtmKit
import Foundation
import SwiftUI
import Combine
import AgoraUIKit
import AVFoundation
import Photos

// this is view model managing all of the stuffs related to video calling
// user will login to a rtm channel when booting the app
// caller will open up a rtc channel send calling request with the channel info to callee through rtm channel
// callee could accept and reject and send the reponse back to caller through rtm channel
// then the caller and callee will join the rtc channel and do video calling
class AgoraManager: NSObject, ObservableObject {
    static let shared = AgoraManager()
    override private init() {
        super.init()
        agoraRTC = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
        agoraRTM = AgoraRtmKit(appId: appId, delegate: self)
        UserDefaults.standard.set(false, forKey: "permissionGranted")
    }
    
    var selfId = ""
    var agoraRTC: AgoraRtcEngineKit!
    var agoraRTM: AgoraRtmKit!
    var agoraRTMChannel: AgoraRtmChannel!
    var appId = "5aef49e730d74beb930fd4a3f79d26f8"
    var rtcToken = "undefined"
    var rtmToken = "undefined"
    let rtmChannelId = "roommate"
    @Published var rtcChannelId = "undefined"
    
    @Published var callerId = ""
    var incomingToken = "undefined"
    var incomingChannelId = "undefined"
    @Published var calleeId = ""
    var opponentId = ""
    
    @Published var currentRtcToken = ""
    @Published var currentRtcChannelId = ""
    
    @Published var showVideoView = false
    @Published var showCallingView = false
    @Published var showIncomingView = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    var agoraVideoViewer: AgoraVideoViewer?
    
    func fetchRTMToken(user: String) -> String {
        let jsonObject: [String: Any] = [
            "user_id": user
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
            guard let tokenServerURL = URL(string: "https://vcm-39030.vm.duke.edu:8081/get_rtm_token") else {
                return ""
            }
            let semaphore = DispatchSemaphore(value: 0)
            var request = URLRequest(url: tokenServerURL, timeoutInterval: 10)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            var tokenToReturn = ""
            
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                defer {
                    semaphore.signal()
                }
                guard let data = data else {
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let token = responseJSON?["token"] as? String {
                    tokenToReturn = token
                }
            }
            task.resume()
            
            semaphore.wait()
            return tokenToReturn
        }
        return ""
    }
    
    func fetchRTCToken(channelName: String, user: String) -> String {
        let jsonObject: [String: Any] = [
            "tokenType": "rtc",
            "channel": channelName,
            "role": "publisher",
            "uid": "0",
            "expire": 3600

        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
            guard let tokenServerURL = URL(string: "https://agora-token-service-production-ccb0.up.railway.app/getToken") else {
                return ""
            }
            let semaphore = DispatchSemaphore(value: 0)
            var request = URLRequest(url: tokenServerURL, timeoutInterval: 10)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            var tokenToReturn = ""
            
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                defer {
                    semaphore.signal()
                }
                guard let data = data else {
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let token = responseJSON?["token"] as? String {
                    tokenToReturn = token
                }
            }
            
            task.resume()
            
            semaphore.wait()
            return tokenToReturn
        }
        return ""
    }
    
    func loginRTM(user: String) {
        self.selfId = user
        if self.rtcChannelId == "undefined" {
            self.rtcChannelId = user
        }
        if self.rtmToken == "undefined" {
            self.rtmToken = fetchRTMToken(user: user)
            print("RTM Token: \(self.rtmToken)")
        }
        agoraRTM.login(byToken: rtmToken, user: user) { [weak self] (errorCode) in
            guard errorCode == .ok else {
                print("Failed to login to RTM")
                return
            }
            print("Logged in to RTM")
            self?.joinRTMChannel(channel: self?.rtmChannelId ?? "")
        }
    }
    
    func joinRTMChannel(channel: String) {
        agoraRTMChannel = agoraRTM.createChannel(withId: channel, delegate: nil)
        agoraRTMChannel.join { (errorCode) in
            guard errorCode == .channelErrorOk else {
                print("Failed to join RTM channel")
                return
            }
            print("Joined RTM channel")
        }
    }
    
    func sendCallRequest(targetUser: String, completion: @escaping (Bool) -> Void) {
        self.rtcToken = fetchRTCToken(channelName: rtcChannelId, user: selfId)
        print("RTC Token: \(self.rtcToken)")
        calleeId = targetUser
        opponentId = targetUser
        let callInfo: [String: String] = [
            "type": "call",
            "token": rtcToken,
            "channel": rtcChannelId
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: callInfo, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            completion(false)
            return
        }
        let message = AgoraRtmMessage(text: jsonString)
        agoraRTM.send(message, toPeer: targetUser) { (errorCode) in
            completion(errorCode == .ok)
            if errorCode != .ok {
                withAnimation {
                    self.showCallingView = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.alertMessage = "Your friends is not online. Please wait and call later."
                        self.showAlert = true
                    }
                }
            }
        }
        withAnimation {
            showCallingView = true
        }
    }
    
    func handleReceivedRTMMessage(_ message: AgoraRtmMessage, from user: String) {
        if let data = message.text.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String] {
            print(String(data: data, encoding: .utf8) ?? "Failed to convert data to string")
            let type = json["type"] ?? "undefined"
            if type == "call" {
                print("Receving calling!")
                self.incomingToken = json["token"] ?? "undefined"
                self.incomingChannelId = json["channel"] ?? "undefined"
                self.callerId = user
                self.opponentId = user
                print("hi still alive")
                withAnimation {
                    showIncomingView = true
                }
            } else if type == "accept" {
                self.currentRtcToken = self.rtcToken
                self.currentRtcChannelId = self.rtcChannelId
                requestMicrophonePermissions()
                requestCameraPermissions()
                withAnimation {
                    self.showVideoView = true
                    showCallingView = false
                }
                print(self.showVideoView)
            } else if type == "decline" {
                withAnimation {
                    showCallingView = false
                }
                print("declined")
            }
            else if type == "end" {
                agoraVideoViewer?.leaveChannel()
                withAnimation {
                    showIncomingView = false
                    showVideoView = false
                }
            }
        }
    }
    
    func acceptCall() {
        let acceptInfo: [String: String] = [
            "type": "accept"
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: acceptInfo, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        let message = AgoraRtmMessage(text: jsonString)
        agoraRTM.send(message, toPeer: opponentId) { (errorCode) in
            if errorCode != .ok {
                return
            }
        }
        self.currentRtcToken = self.incomingToken
        self.currentRtcChannelId = self.incomingChannelId
        requestCameraPermissions()
        requestMicrophonePermissions() 
        withAnimation {
            showVideoView = true
            showIncomingView = false
        }
    }
    
    
    func declineCall() {
        let acceptInfo: [String: String] = [
            "type": "decline"
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: acceptInfo, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        let message = AgoraRtmMessage(text: jsonString)
        agoraRTM.send(message, toPeer: opponentId) { (errorCode) in
            if errorCode != .ok {
                return
            }
        }
        withAnimation {
            showIncomingView = false
        }
    }
    
    func endCall() {
        let acceptInfo: [String: String] = [
            "type": "end"
        ]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: acceptInfo, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            return
        }
        let message = AgoraRtmMessage(text: jsonString)
        agoraRTM.send(message, toPeer: opponentId) { (errorCode) in
            if errorCode != .ok {
                return
            }
        }
    }
    
    func logoutRTM() {
        agoraRTMChannel.leave { (errorCode) in
            guard errorCode == .ok else {
                print("Failed to leave RTM channel")
                return
            }
            print("Left RTM channel")
        }
        agoraRTM.logout { (errorCode) in
            guard errorCode == .ok else {
                print("Failed to logout from RTM")
                return
            }
            print("Logged out from RTM")
        }
    }
}

func requestMicrophonePermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .audio) {
    case .authorized:
        break
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            guard granted else {
                print("Microphone permissions not granted")
                return
            }
            if granted {
                print("Microphone permissions granted")
            } else {
                print("Microphone permissions not granted")
            }
        }
        case .denied:
            print("Microphone permissions not granted")
            break
        case .restricted:
            print("Microphone permissions not granted")
            break
        @unknown default:
            break
    }
}

func requestCameraPermissions() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
        break
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: .video) { granted in
            guard granted else {
                print("Camera permissions not granted")
                return
            }
            if granted {
                print("Camera permissions granted")
            } else {
                print("Camera permissions not granted")
            }
        }
        case .denied:
            print("Camera permissions not granted")
            break
        case .restricted:
            print("Camera permissions not granted")
            break
        @unknown default:
            break
    }
}

func requestPhotoLibraryPermission() {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
        break
    case .notDetermined:
        PHPhotoLibrary.requestAuthorization { newStatus in
            if newStatus == .authorized {
                print("PhotoLibranry permissions granted")
            } else {
                print("PhotoLibranry permissions not granted")
            }
        }
    case .denied, .restricted:
        print("PhotoLibranry permissions not granted")
        break
    case .limited:
        print("PhotoLibranry permissions not granted")
        break
    @unknown default:
        fatalError("Unknown authorization status")
    }
}

extension AgoraManager: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        print("hi, receiving message!!")
        DispatchQueue.main.async { [weak self] in
            self?.handleReceivedRTMMessage(message, from: peerId)
        }
    }
}
