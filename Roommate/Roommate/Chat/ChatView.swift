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
            Text("hi")
        }
    }
}

//#Preview {
//    ChatView()
//}
