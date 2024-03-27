//
//  editProfileView.swift
//  Roommate
//
//  Created by Andrew Huang on 3/26/24.
//

import SwiftUI

struct editProfileView: View {
    var switched: Bool = false
    @Binding var user: User //need to modify the user, and run a save
    var profileImages: [UIImage] = []
    var body: some View {
        HStack{
            Spacer()
            Text("Edit")
            Spacer()
            Divider()
            Spacer()
            Text("Preview")
            Spacer()
        }
        .frame( height: 30)
        
        Divider()
        Text("Whats up in this")
        Spacer()
    }
}
/*
 #Preview {
 editProfileView()
 }
 */
