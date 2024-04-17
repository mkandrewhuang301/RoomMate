//
//  profilePic.swift
//  Roommate
//
//  Created by Andrew Huang on 3/20/24.
//

import SwiftUI

// this is the view on profile page
// including photo and a ring indicating the
// completeness of someone's profile
struct profilePic: View {
    var photo: String
    @Binding var user: User
    let height: Double
    let width: Double
    var percent: Double
    @State var percent2: Double = 0

    let total: Double = 17 ///number of variables needed to be set in USER
    @State var count: Double = 0
    //@State var percent: Double = 0
    var color: Color = Color("crystal")
    
    var body: some View {
        VStack{
            if let imageData = Data(base64Encoded: photo), let UIImage = UIImage(data: imageData){
                Image(uiImage: UIImage)
                    .resizable()
                    .clipShape(Circle())
                    .overlay(circleOverlay)
                    .overlay(circleOverlay2)
                    .shadow(radius:10)
                    .frame(width: width, height: height)
            }
            else{
                Image("avatar")
                    .resizable()
                    .clipShape(Circle())
                    .overlay(circleOverlay)
                    .shadow(radius:10)
                    .frame(width: width, height: height)
            }
            Text("\(Int(percent*100))%")
                .background(color)
                //.background(Color(red: 0.95, green: 0.95, blue: 0.92))
                .cornerRadius(7)
                .offset(y:-47)
                .foregroundColor(.white)
                .frame(width: 100, height: 40)
                .font(.custom("Helvetica Neue", size: 16))
                .fontWeight(.bold)
                //.frame(width:30, height:20)
            
        }
        .onChange(of: percent, initial: false) { oldValue, newValue in
                    withAnimation {
                        percent2 = newValue
                    }
                }
        .onAppear{
            DispatchQueue.main.async {
                percent2 = percent
            }
            //percent2 = percent
        }
    }
    private var circleOverlay: some View{
        Circle()
            .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: CGFloat(percent2))
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
            .rotation(Angle(degrees: -180))
            .animation(.easeInOut(duration:1), value:percent2)
            .foregroundColor(color)
            .padding(-5)
            
    }
    private var circleOverlay2: some View{
        Circle()
            .trim(from: CGFloat(percent2), to: 1.0)
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
            .rotation(Angle(degrees: -180))
            .foregroundColor(.gray.opacity(0.25))
            .padding(-5)
            .animation(.easeInOut(duration:1), value:percent2)
    }
}
/*
 #Preview {
 profilePic()
 }
 */
