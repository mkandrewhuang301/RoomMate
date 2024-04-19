//
//  mainPhotoView.swift
//  Roommate
//
//  Created by Andrew Huang on 4/4/24.
//

import SwiftUI

// this is the view for the draggable photo component in the main page
struct mainPhotosViewer: View {
    @Binding var index: Int
    @Binding var profile: User
    @Binding var user: User
    var isDraggable: Bool
    @State var showDetail: Bool = false
    var showName = true
    var showAge = true
    var showInterests = true
    var showDetailButton = true
    var cardStyle = true
    @State private var currentIndex = 0
    @State private var screenWidth : CGFloat = 0
    @ObservedObject var dataModel: Database  = Database.shared
    
    
    ///card animation variables
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0
    @State var initialSwipe: DragDirection? = nil
    @State var isSwipeDown: Bool = false
    @StateObject var uploadViewModel = UploadViewModel()
    var barWidth: CGFloat {
        return (screenWidth - 50 - CGFloat(8 * (profile.photos.count - 1))) / CGFloat(profile.photos.count)
    }
    
    var selectedInterests: [String] {
        if profile.interests.count <= 2 {
            return profile.interests
        } else {
            return Array(profile.interests.prefix(2))
        }
    }
    enum DragDirection {
            case up
            case down
        }
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    screenWidth = geometry.size.width
                }
        }
        ZStack {
            if let imageData = Data(base64Encoded: profile.photos[currentIndex]), let UIImage = UIImage(data: imageData) {
                Image(uiImage: UIImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: cardStyle ? (screenWidth - 20) : screenWidth, height: 550)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: cardStyle ? 25 : 0))
            
                    .onTapGesture { location in
                        if isDraggable{
                            let halfWidth = screenWidth / 2
                            let isRightSide = location.x > halfWidth
                            if isRightSide {
                                currentIndex = currentIndex < profile.photos.count - 1 ? currentIndex + 1 : currentIndex
                            } else {
                                currentIndex = currentIndex > 0 ? currentIndex - 1 : 0
                            }
                        }
                    }
                 
                    
                    .offset(x: offsetX, y: offsetY )
            }
            Image("dope")
                .resizable()
                .frame(width: 220, height: 110)
                //.opacity(isDraggable ? 1 : 0)
                .rotationEffect(.degrees(-30))
                .opacity(isDraggable ? 0 + abs(offsetX > 0 ? offsetX: 0) * 0.008: 0 )
                .offset(x:offsetX - 90, y: offsetY - 150)
            
            Image("nope")
                .resizable()
                .frame(width: 240, height: 160)
               // .opacity(isDraggable ? 1 : 0)
                .rotationEffect(.degrees(32))
                .opacity(isDraggable ? 0 + abs(offsetX < 0 ? offsetX: 0) * 0.008: 0 )
                .offset(x:offsetX + 90, y: offsetY - 150)
            
                
            if showDetailButton {
                Button(action: {
                    showDetail.toggle()
                }) {
                    Image(systemName: "arrowshape.up.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .padding()
                        .clipShape(Circle())
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                        
                }
                .position(x: 350 + offsetX, y: 500 + offsetY )
            }
            VStack (alignment: .leading) {
                HStack {
                    if showName {
                        Text(profile.fName)
                            .font(.custom("Avenir", size: 40))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 3, x: 0, y: 2)
                    }
                    if showAge {
                        Text(String(profile.age))
                            .font(.custom("Avenir", size: 35))
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 2.8, x: 0, y: 2)
                    }
                }
                if showInterests {
                    Text("Interests")
                        .font(.custom("Avenir", size: 20))
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 2.8, x: 0, y: 2)
                    WrapView(items: selectedInterests) { interest in
                        InterestBulletView(interest: interest)
                    }
                }
            }
            .position(x: 210 + offsetX, y: 830 + offsetY)
            HStack(spacing: 3) {
                ForEach(0..<profile.photos.count, id: \.self) { index in
                    Rectangle()
                        .fill(index == currentIndex ? Color.white : Color.gray.opacity(0.5))
                        .frame(width: barWidth, height: 5)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(white: 0.3).opacity(0.3), lineWidth: 2)
                        )
                }
            }
            .offset(x: offsetX, y: -260 + offsetY)
        }
        .rotationEffect(.degrees(Double(offsetX * CGFloat(isSwipeDown ? 1 : -1) * 0.05)))
        .highPriorityGesture(
                DragGesture()
                    .onEnded{ gesture in
                        if isDraggable{
                            let location = gesture.location
                            let limit = 2*screenWidth / 7
                            let isRightSide = (location.x - gesture.startLocation.x) > limit
                            let isLeftSide = (gesture.startLocation.x - location.x)  >  limit
                            //print("\(limit), \(gesture.startLocation.x), and  \(location.x), \(total)")
                            if isRightSide{
                                withAnimation(.easeIn(duration: 0.28)) {
                                    self.offsetX = 800
                                }completion: {
                                    user.applyList.append(profile.id)
                                    let jsonObject = [
                                        "myid": user.id.uuidString,
                                        "matchid": profile.id.uuidString
                                    ]
                                    if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
                                        if !uploadViewModel.upload(website: "http://vcm-39030.vm.duke.edu:8080/roommate/apply", json: jsonData) {
                                            print("Failed to start upload task")
                                            return
                                        }
                                    }
                                    currentIndex = 0
                                    user.applyList.append(profile.id)
                                    index += 1
                                    print(user.applyList.count)
                                    user.seen.append(profile.id)
                                }
                                
                            }
                            else if isLeftSide{
                                
                                withAnimation(.easeIn(duration: 0.28)) {
                                    self.offsetX = -800
                                }completion: {
                                    currentIndex = 0
                                    index += 1
                                    user.seen.append(profile.id)
                                }
                                
                            }
                        
                            else{
                                withAnimation(.easeInOut(duration: 0.8)) {
                                    self.offsetX = 0
                                    self.offsetY = 0
                                    
                                }
                            }
                         
                            initialSwipe = nil
                        }
                    }
                    .onChanged(){ gesture in
                        if isDraggable {
                            let x = gesture.translation.width
                            let y = gesture.translation.height
                            self.offsetX = x
                            self.offsetY = y
                            if initialSwipe == nil {
                                if y  > 0 {
                                    initialSwipe  = .down
                                    isSwipeDown = true
                                }
                                else{
                                    initialSwipe = .up
                                    isSwipeDown = false
                                }
                            }
                        }
                    }
        )
        .onChange(of: index){
            offsetX = 0
            offsetY = 0
        }
        .fullScreenCover(isPresented: $showDetail) {
            
            OtherProfileDetailView(user: $profile, showDetail: $showDetail)
        }
    }
}

//#Preview {
//    PhotoViewer()
//}

