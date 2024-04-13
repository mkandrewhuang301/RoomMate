//
//  ContentView.swift
//  Roommate
//
//  Created by Spring2024 on 3/15/24.
//

import SwiftUI
import ECE564Login


struct ContentView: View {
    @ObservedObject var dataModel: Database  = Database.shared
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
                TabView(selection: $selectedTab){
                    ZStack{
                        
                        HStack{
                            
                            Image("appText")
                                .resizable()
                                
                        }
                        .offset(y: -300)
                        .frame(width: 200, height: 50)
                         
                        //showDetail = false
                        
                        if userList.count > userIndex + 1{
                            mainPhotosViewer(index: $userIndex, profile: $userList[userIndex + 1],  user: dataModel.bindingForCurrentUser(), isDraggable: false)
                        }
                        if userList.count > userIndex{
                            mainPhotosViewer(index: $userIndex, profile: $userList[userIndex], user: dataModel.bindingForCurrentUser(), isDraggable: true)
                        }
                            
                        
                    }
                    .tabItem{
                        Label("", systemImage:"circle.hexagongrid.circle.fill")
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
                    }
                    .tag(1)
                    
                    NavigationView{
                        ChatView(user: dataModel.bindingForCurrentUser())
                    }
                    .tabItem {
                        Label("", systemImage: "message.fill")
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
            else{
                Text("Loading...")
            }
            
            Text("")
            //ECE564Login()
          //.onDisappear(){
            .onAppear(){
                let netID = "ah629"
              //let netID = UserDefaults.standard.string(forKey: "AuthString")!.components(separatedBy: ":")[0]
                DownloadManager<User>().downloadData(url: "http://vcm-39030.vm.duke.edu:8080/roommate/user/\(netID)"){ result in
                    switch result{
                        //when user not found, just use new profile
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
    }
        
}

#Preview {
    ContentView()
}

