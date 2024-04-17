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

// this is the view when you click the photo to edit
// the profile and it will show
struct ProfileEditTabView: View {
    var switched: Bool = false
    @Binding var user: User 
    @Binding var showOverlay: Bool
    var profileImages: [UIImage] = []
    @State private var selectedTab: Tab = .edit
    @StateObject var uploadViewModel = UploadViewModel()
    @State private var tmpUser: User

    init(user: Binding<User>, showOverlay: Binding<Bool>) {
        self._user = user
        self._showOverlay = showOverlay
        self._tmpUser = State(initialValue: user.wrappedValue)
    }

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
                        user = tmpUser
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
                    ProfileEditView(user: $tmpUser)
                case .preview:
                    OtherProfileView(user: $tmpUser)
            }
            Spacer()
        }
        .transition(.move(edge: .bottom))
        .background(.white)
    }
}

/*
 #Preview {
 editProfileView()
 }
 */
