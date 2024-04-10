import AgoraRtcKit
import AgoraRtmKit

class AgoraManager: ObservableObject {
    var agoraRTC: AgoraRtcEngineKit!
    var agoraRTM: AgoraRtmKit!
    var agoraRTMChannel: AgoraRtmChannel!
    let appId = "5aef49e730d74beb930fd4a3f79d26f8"
    let token = "undefined"
    let rtmToken = "undefined"
    let rtmChannelId = "roommate"
    let channelId = "test"
    
    @Published var incomingCall = false
    @Published var callerId = ""

    init() {
        agoraRTC = AgoraRtcEngineKit.sharedEngine(withAppId: appId, delegate: nil)
        agoraRTM = AgoraRtmKit(appId: appId, delegate: nil)
    }
    
    func fetchRTM
    
    func loginRTM(user: String) {
        // fetch rtm token
        
        agoraRTM.login(byToken: rtmToken, user: user) { [weak self] (errorCode) in
            guard errorCode == .ok else { return }
            self?.joinRTMChannel(channel: self?.rtmChannelId ?? "")
        }
    }
    
    func joinRTMChannel(channel: String) {
        agoraRTMChannel = agoraRTM.createChannel(withId: channel, delegate: nil)
        agoraRTMChannel.join { (errorCode) in
            guard errorCode == .ok else { return }
            // 成功加入RTM频道
        }
    }
    
    func sendCallRequest(targetUser: String, completion: @escaping (Bool) -> Void) {
        // fetch rtc token with channel name
        let message = AgoraRtmMessage(text: "callRequest")
        agoraRTM.send(message, toPeer: targetUser) { (errorCode) in
            completion(errorCode == .ok)
        }
    }
    
    func handleReceivedRTMMessage(_ message: AgoraRtmMessage, from user: String) {
            if message.text == "callRequest" {
                self.incomingCall = true
                self.callerId = user
            }
        }

    // 新增：接受呼叫并加入RTC频道的逻辑
    func acceptCall() {
        // 加入RTC频道，开始视频通话
        agoraRTC.joinChannel(byToken: token, channelId: channelId, info: nil, uid: 0) { [weak self] (channel, uid, elapsed) in
            // 可以在这里更新UI，比如显示通话界面
        }
    }
}

extension AgoraManager: AgoraRtmDelegate {
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        DispatchQueue.main.async { [weak self] in
            self?.handleReceivedRTMMessage(message, from: peerId)
        }
    }
}
