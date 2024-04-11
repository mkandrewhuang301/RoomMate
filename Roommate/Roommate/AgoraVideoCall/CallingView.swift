//
//  CallingView.swift
//  Roommate
//
//  Created by Spring2024 on 4/11/24.
//

import SwiftUI

struct CallingView: View {
    var calleeName: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                    .frame(height: 100)
                Text("Calling...")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                Text(calleeName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
}


#Preview {
    CallingView(calleeName: "Alice")
}
