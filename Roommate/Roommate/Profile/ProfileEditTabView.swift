//
//  editProfileView.swift
//  Roommate
//
//  Created by Andrew Huang on 3/26/24.
//

import SwiftUI

enum Tab {
    case edit
    case preview
}

struct ProfileEditTabView: View {
    var switched: Bool = false
    @Binding var user: User 
    @Binding var showOverlay: Bool
    var profileImages: [UIImage] = []
    @State private var selectedTab: Tab = .edit
    @StateObject var uploadViewModel = UploadViewModel()
    
    var body: some View {
        VStack {
            ZStack {
                HStack{
                    Spacer()
                    Text("Edit Info")
                        .font(.custom("Helvetica Neue", size: 20))
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    Spacer()
                }
                HStack {
                    Button("Cancel") {
                        withAnimation {
                            showOverlay.toggle()
                        }
                    }
                    .font(.custom("Helvetica Neue", size: 16))
                    .fontWeight(.bold)
                    Spacer()
                    Button("Save") {
                        if !uploadViewModel.upload(website: "http://vcm-39030.vm.duke.edu:8080/roommate/modify-profile", user: user) {
                            print("Failed to start upload task")
                        }
                        withAnimation {
                            showOverlay.toggle()
                        }
                    }
                    .font(.custom("Helvetica Neue", size: 16))
                    .fontWeight(.bold)
                }
            }
            .padding()
            
            HStack {
                Button("Edit") {
                    selectedTab = .edit
                }
                .font(.custom("Helvetica Neue", size: 20))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == .edit ? Color.accentColor : .gray)
                Divider()
                    .frame(maxHeight: 30)
                    .padding(.horizontal, 2)
                Button("Preview") {
                    selectedTab = .preview
                }
                .font(.custom("Helvetica Neue", size: 20))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == .preview ? Color.accentColor : .gray)
            }
            
            switch selectedTab {
                case .edit:
                    ProfileEditView(user: $user)
                case .preview:
                    OtherProfileView(user: $user)
            }
            Spacer()
        }
        .transition(.move(edge: .bottom))
        .background(.white)
    }
}

class UploadViewModel: NSObject, ObservableObject, URLSessionDelegate, URLSessionDataDelegate {
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertInfo: String = ""
    @Published var showUploadAlert: Bool = false
    
    func upload(website: String, user: User) -> Bool {
        let url = URL(string: website)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session : URLSession = {
            let config = URLSessionConfiguration.ephemeral
            config.allowsCellularAccess = false
            let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
            return session
        }()
        
        let encoder = JSONEncoder()
        var jsonData: Data
        do {
            jsonData = try encoder.encode(user)
        } catch {
            return false
        }
        print(String(data: jsonData, encoding: .utf8)!)
        request.httpBody = jsonData
        let task = session.dataTask(with: request)
        task.resume()
        return true
    }
    
    func upload(website: String, json: Data) -> Bool {
        let url = URL(string: website)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session : URLSession = {
            let config = URLSessionConfiguration.ephemeral
            config.allowsCellularAccess = false
            let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
            return session
        }()
        
//        let encoder = JSONEncoder()
//        var jsonData: Data
//        do {
//            jsonData = try encoder.encode(user)
//        } catch {
//            return false
//        }
//        print(String(data: jsonData, encoding: .utf8)!)
        request.httpBody = json
        let task = session.dataTask(with: request)
        task.resume()
        return true
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            self.alertTitle = "Upload Fail!"
            self.alertInfo = "Please try again!"
            self.showAlert = true
        } else {
            self.alertTitle = "Upload Success!"
            self.alertInfo = "Please download again and check!"
            self.showAlert = true
            print("Upload successfully")
        }
    }
}


/*
 #Preview {
 editProfileView()
 }
 */
