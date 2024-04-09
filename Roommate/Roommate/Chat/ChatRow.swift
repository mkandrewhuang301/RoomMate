//
//  ChatRow.swift
//  Roommate
//
//  Created by Spring2024 on 4/9/24.
//

import SwiftUI

struct ChatRow: View {
    @Binding var user: User
    var body: some View {
        HStack {
            profilePic(photo: user.photos[0], user: user, height: 10, width: 10, percent: .constant(0))
        }
    }
}

//#Preview {
//    ChatRow()
//}
