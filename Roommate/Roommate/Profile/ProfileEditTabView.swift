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
    @State private var selectedTab: Tab = .preview
    
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
                    Spacer()
                    Button("Save") {
                        // logic of saving
                        withAnimation {
                            showOverlay.toggle()
                        }
                    }
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
                .foregroundColor(selectedTab == .edit ? .red : .gray)
                Divider()
                    .frame(maxHeight: 30)
                    .padding(.horizontal, 2)
                Button("Preview") {
                    selectedTab = .preview
                }
                .font(.custom("Helvetica Neue", size: 20))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == .preview ? .red : .gray)
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
/*
 #Preview {
 editProfileView()
 }
 */
