//
//  ChatView.swift
//  Roommate
//
//  Created by Andrew Huang on 3/19/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var dataModel: Database  = Database.shared
    @Binding var user: User
    @ObservedObject var agoraManager: AgoraManager = AgoraManager.shared
    @StateObject var uploadViewModel = UploadViewModel()
    @State private var showProfile = false
    @State private var showUser: User = User()
    
    var dedupedFriendList: [UUID] {
        Array(Set(user.friends))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) { // headline
                Spacer()
                Image("iconimage")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("RoomMate")
                    .font(.custom("Futura", size: 28))
                    .bold()
                    .foregroundStyle(Color.accentColor)
                    .frame(height: 50)
                Spacer()
            }
            .padding()
            .frame(height: 80)
            List {
                Section(header:  // new match line
                    HStack {
                        Text("New Matches")
                            .font(.custom("Helvetica Neue", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding(.vertical)
                        Spacer()
                        Button(action: {
                            let netID = user.netId
                            DownloadManager<User>().downloadData(url: "http://vcm-39030.vm.duke.edu:8080/roommate/user/\(netID)"){ result in
                                switch result{
                                    case .failure( _):
                                        dataModel.setCurrentUser(User())
                                        return true
                                    case .success(let user):
                                        dataModel.setCurrentUser(user)
                                        return true
                                }
                            }
                        }
                    ) {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("crystal"))
                    }
                }
                ) {
                    NewMatchView(user: $user, showProfile: $showProfile, showUser: $showUser)
                }
                
                Section(header: Text("Contacts") // contacts to call
                    .font(.custom("Helvetica Neue", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.vertical)
                ) {
                    // get a deduplicated friend uuid list
                    ForEach(dedupedFriendList, id: \.self) { friend_uuid in
                            let friend = dataModel.bindingForUser(friend_uuid)
                            ChatRow(user: friend)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button {
                                    let jsonObject = [
                                        "myid": user.id.uuidString,
                                        "matchid": friend_uuid.uuidString
                                    ]
                                    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
                                        if !uploadViewModel.upload(website: "http://vcm-39030.vm.duke.edu:8080/roommate/delete", json: jsonData) {
                                            print("Failed to start upload task")
                                            return
                                        }
                                    }
                                    user.friends.removeAll { $0 == friend.id }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showProfile) {
            OtherProfileDetailView(user: $showUser, showDetail: $showProfile)
        }
        .onAppear() {
            let netID = user.netId
            DownloadManager<User>().downloadData(url: "http://vcm-39030.vm.duke.edu:8080/roommate/user/\(netID)"){ result in
                switch result{
                    case .failure( _):
                        dataModel.setCurrentUser(User())
                        return true
                    case .success(let user):
                        dataModel.setCurrentUser(user)
                        return true
                }
            }
        }
    }
}

//#Preview {
//    ChatView()
//}
