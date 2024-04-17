//
//  ContentView.swift
//  Roommate
//
//  Created by Spring2024 on 3/15/24.
//

import SwiftUI
import ECE564Login
import UIKit
import AudioToolbox

struct ContentView: View {
    @ObservedObject var dataModel: Database  = Database.shared
    @ObservedObject var agoraManager: AgoraManager = AgoraManager.shared
    @StateObject private var downloadManager = DownloadManager<[User]>()
    @State private var currentNetID: String = ""
    @State private var isViewVisible: Bool = false
    @State var userList: [User]  = []
    @State var isDownloadComplete: Bool = false
    
    //user details:
    @State var userIndex: Int = 0
    @State private var selectedTab: Int = 0
    var body: some View {
        ZStack {
            if isDownloadComplete {
                VStack{
                    TabView(selection: $selectedTab){
                        ZStack() {
                            VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                    Spacer()
                                        .frame(width: 10)
                                    Image("iconimage")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                    Text("RoomMate")
                                        .font(.custom("Futura", size: 24))
                                        .bold()
                                        .foregroundStyle(Color.accentColor)
                                        .frame(height: 40)
                                    Spacer()
                                    //user offset instead of it
                                }
                                .frame(height: 40)
                                .padding(.vertical, 10)
                                Image("background")
                                    .resizable()
                                    .edgesIgnoringSafeArea(.bottom)
                                    .opacity(0.6)
                                    //.frame(height: 650)
                            }
                            ZStack{
                                //showDetail = false
                                if userList.count > userIndex + 1{
                                    mainPhotosViewer(index: $userIndex, profile: $userList[userIndex + 1],  user: dataModel.bindingForCurrentUser(), isDraggable: false)
                                }
                                if userList.count > userIndex{
                                    mainPhotosViewer(index: $userIndex, profile: $userList[userIndex], user: dataModel.bindingForCurrentUser(), isDraggable: true)
                                }
                            }
                        }
                        .tabItem{
                            Label("", systemImage:"circle.hexagongrid.circle.fill")
                                .padding()
                                .frame(height: 60)
                        }
                        .tag(0)
                        .onChange(of: selectedTab){ _ , _ in
                            if selectedTab == 0 {
                                userList = dataModel.filter()
                            }
                            print("HERE")
                            print(userList.count)
                            userIndex = 0
                            
                        }
                        
                        NavigationView{
                            BlogView()
                        }
                        .tabItem{
                            Label("", systemImage:"house")
                                .padding()
                                .frame(height: 60)
                        }
                        .tag(1)
                        
                        NavigationView{
                            ChatView(user: dataModel.bindingForCurrentUser())
                        }
                        .tabItem {
                            Label("", systemImage: "message.fill")
                                .padding()
                                .frame(height: 60)
                        }
                        .tag(2)
                        
                        NavigationView{
                            //var s: String = "123"
                            ProfileView(user: dataModel.bindingForCurrentUser())
                        }
                        .tabItem {
                            Label("", systemImage: "person.fill")
                        }
                        .tag(3)
                    }
                }
            }
            else{
                Text("Loading...")
            }
            
            Text("")
            ECE564Login()
                      
            .onDisappear(){
//                           .onAppear(){
//                let netID = "njw30"
                let netID = UserDefaults.standard.string(forKey: "AuthString")!.components(separatedBy: ":")[0]
                
                DownloadManager<User>().downloadData(url: "http://vcm-39030.vm.duke.edu:8080/roommate/user/\(netID)"){ result in
                    switch result{
                        //when user not found, just use new profile
                    case .failure( _):
                        dataModel.setCurrentUser(User())
                        return true
                    case .success(let user):
                        dataModel.setCurrentUser(user)
                        agoraManager.loginRTM(user: user.id.uuidString)
                        return true
                    }
                }
            }
        }
        .background(.white)
        .onAppear{
            downloadManager.downloadData(url: "http://vcm-39030.vm.duke.edu:8080/roommate/list"){result in
                switch result{
                    case .success(let users):
                        let _ = dataModel.replaceDB(users: users)
                        //userList = dataModel.list()
                        userList = dataModel.filter()
                        isDownloadComplete = true
                        return true
                    case .failure(let error):
                        // Handle the error, perhaps setting an error message state variable
                        print("Error downloading user data: \(error.localizedDescription)")
                        return false
                    }

                }
            }
        .onChange(of: agoraManager.showIncomingView, initial: false) { oldValue, newValue in
            if newValue {
                startVibrating()
            } else {
                stopVibrating()
            }
        }
        .fullScreenCover(isPresented: $agoraManager.showCallingView) {
            let name = dataModel.find(UUID(uuidString: agoraManager.calleeId)!)?.fName ?? ""
            CallingView(calleeName: name)
        }
        .fullScreenCover(isPresented: $agoraManager.showVideoView) {
            VideoCallView()
        }
        .fullScreenCover(isPresented: $agoraManager.showIncomingView) {
            let name = dataModel.find(UUID(uuidString: agoraManager.callerId)!)?.fName ?? ""
            IncomingView(callerName: name)
        }
        .alert("Call Request", isPresented: $agoraManager.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(agoraManager.alertMessage)
        }
    }
    
}

private var vibrationTimer: Timer?
    
func startVibrating() {
    stopVibrating()
    vibrationTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
        triggerVibration()
    }
}

func stopVibrating() {
    vibrationTimer?.invalidate()
}

func triggerVibration() {
    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
}

#Preview {
    ContentView()
}

