//
//  NewMatchView.swift
//  Roommate
//
//  Created by Spring2024 on 4/9/24.
//

import SwiftUI

struct NewMatchView: View {
    @ObservedObject var dataModel: Database  = Database.shared
    @Binding var user: User
    let minimumMatch = 5
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack (spacing: 25){
                ForEach(user.waitList, id: \.self) { friend_uuid in
                    let friend = dataModel.bindingForUser(friend_uuid)
                    NewMatchItem(user: $user, friend: friend)
                }
                ForEach(0..<max(minimumMatch - user.waitList.count, 0), id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(red: 233/255, green: 234/255, blue: 238/255))
                        .frame(width: 120, height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(style: StrokeStyle(lineWidth: 7, dash: [12]))
                                .foregroundColor(Color(red: 185/255, green: 191/255, blue: 200/255))
                        )
                }
                .padding(.vertical)
            }
        }
    }
}

//#Preview {
//    NewMatchView()
//}
