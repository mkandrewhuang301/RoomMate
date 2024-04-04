//
//  PhotosView.swift
//  Roommate
//
//  Created by Spring2024 on 4/3/24.
//

import SwiftUI

struct PhotosViewer: View {
    @Binding var user: User
    @Binding var showDetail: Bool
    var showName = true
    var showAge = true
    var showInterests = true
    var showDetailButton = true
    var cardStyle = true
    @State private var currentIndex = 0
    @State private var screenWidth : CGFloat = 0
    var barWidth: CGFloat {
        return (screenWidth - 50 - CGFloat(8 * (user.photos.count - 1))) / CGFloat(user.photos.count)
    }
    
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    screenWidth = geometry.size.width
                }
        }
        ZStack {
            if let imageData = Data(base64Encoded: user.photos[currentIndex]), let UIImage = UIImage(data: imageData) {
                Image(uiImage: UIImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cardStyle ? screenWidth - 20 : screenWidth, height: 550)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: cardStyle ? 25 : 0))
                    .onTapGesture { location in
                        let halfWidth = screenWidth / 2
                        let isRightSide = location.x > halfWidth
                        if isRightSide {
                            currentIndex = currentIndex < user.photos.count - 1 ? currentIndex + 1 : currentIndex
                        } else {
                            currentIndex = currentIndex > 0 ? currentIndex - 1 : 0
                        }
                    }
            }
            if showDetailButton {
                Button(action: {
                    showDetail.toggle()
                }) {
                    Image(systemName: "arrowshape.up.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                        .padding()
                        .clipShape(Circle())
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                }
                .position(x: 310, y: 410)
            }
            VStack (alignment: .leading) {
                HStack {
                    if showName {
                        Text(user.fName)
                            .font(.custom("Avenir", size: 40))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    }
                    if showAge {
                        Text(String(user.age))
                            .font(.custom("Avenir", size: 35))
                            .foregroundColor(.white)
                    }
                }
                if showInterests {
                    Text("Interests")
                        .font(.custom("Avenir", size: 20))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    WrapView(items: user.interests, selectedItems: $user.interests) { interest in
                        InterestBulletView(interest: interest)
                    }
                }
            }
            .position(x: 210, y: 450)
            HStack(spacing: 8) {
                ForEach(0..<user.photos.count, id: \.self) { index in
                    Rectangle()
                        .fill(index == currentIndex ? Color.white : Color.gray.opacity(0.5))
                        .frame(width: barWidth, height: 5)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
            }
            .offset(y: -260)
        }
    }
}

extension View {
    func onTapGesture(location: @escaping (CGPoint) -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    location(value.startLocation)
                }
        )
    }
}

struct InterestBulletView: View {
    let interest: String

    var body: some View {
    Text(interest)
            .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.vertical, 5)
        .fontWeight(.bold)
        .background(.gray)
        .cornerRadius(20)
    }
}

//#Preview {
//    PhotoViewer()
//}
