//
//  OtherProfileView.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

// this is the profileview shown from other users' view
struct OtherProfileView: View {
    @Binding var user: User
    @State private var showDetail = false
    var body: some View {
        VStack {
            PhotosViewer(user: $user, showDetail: $showDetail)
                .padding()
            Spacer()
        }
        .fullScreenCover(isPresented: $showDetail) {
            OtherProfileDetailView(user: $user, showDetail: $showDetail)
        }
    }
}

//#Preview {
//    OtherProfileView()
//}
