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
    
    var body: some View {
        List {
            Section(header: Text("New Matches")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.vertical)
            ) {
                NewMatchView(user: $user)
            }
            Section(header: Text("Contacts")
                .font(.custom("Helvetica Neue", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.vertical)
            ) {
                ForEach(user.friends, id: \.self) { friend_uuid in
                    let friend = dataModel.bindingForUser(friend_uuid)
                    ChatRow(user: friend)
                }
            }
        }
    }
}

//#Preview {
//    ChatView()
//}
