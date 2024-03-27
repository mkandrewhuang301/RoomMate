//
//  profilePic.swift
//  Roommate
//
//  Created by Andrew Huang on 3/20/24.
//

import SwiftUI

struct profilePic: View {
    var photo: String
    var user: User
    let height: Double
    let width: Double
    let total: Double = 17 ///number of variables needed to be set in USER
    @State var count: Double = 0
    @State var percent: Double = 0
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
                .background(.purple)
                //.background(Color(red: 0.95, green: 0.95, blue: 0.92))
                .cornerRadius(7)
                .offset(y:-47)
                .foregroundColor(.white)
                .frame(width: 100, height: 40)
                //.frame(width:30, height:20)
                
        }
        .onAppear{
            count = 0
            if(user.DUID != 0){
                count+=1
                print(1)
            }
            if(user.netId != ""){
                count+=1
                print(2)
            }
            if(user.fName != "Unknown"){
                count+=1
                print(3)
            }
            if(user.lName != "Unknown"){
                count+=1
                print(4)
            }
            if(user.gender != .Unknown){
                count+=1
                print(5)
            }
            if(user.purpose != .Unknown){
                count+=1
                print(6)
            }
            if(!user.photos.isEmpty){
                count+=1
                print(7)
            }
            if(user.school != .NotApplicable){
                count+=1
                print(8)
            }
            //self.program = program ?? .NotApplicable
            if(user.major != .NotApplicable){
                count+=1
                print(9)
            }
            if(user.gradYear != 0){
                count+=1
                print(10)
            }
            if(!(user.sleepSchedule.min ==  0 && user.sleepSchedule.max == 0)){
                count+=1
                print(11)
            }
            if(!(user.budget.min ==  0 && user.budget.max == 0)){
                count+=1
                print(12)
            }
            /*
            if(user.isSmoke == false){
                count+=1
            }
            if(user.havePets == false){
                count+=1
            }
             */
            if(user.selfIntro != ""){
                count+=1
                print(13)
            }
            ///ROOM IS OPTIONAL
            //self.room = room ?? Room()
            
            ///need number of elements  in  Preferences
            //Get preference elements
            if(user.preference.gender != .Unknown){
                count+=1
                print(14)
            }
            if(!(user.preference.ageRange.min ==  0 && user.preference.ageRange.max == 0)){
                count+=1
                print(15)
            }
            
            if(user.location != ""){
                count+=1
                print(16)
            }
            if(!user.interests.isEmpty){
                count+=1
                print(17)
            }
            print(count)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                percent = count / total
            }
        }
    }
    private var circleOverlay: some View{
        Circle()
            .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: CGFloat(percent))
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
            .rotation(Angle(degrees: -180))
            .foregroundColor(.purple)
            .padding(-5)
            .animation(.easeInOut(duration:1), value:percent)
    }
    private var circleOverlay2: some View{
        Circle()
            .trim(from: CGFloat(percent), to: 1.0)
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round))
            .rotation(Angle(degrees: -180))
            .foregroundColor(.gray.opacity(0.25))
            .padding(-5)
            .animation(.easeInOut(duration:1), value:percent)
    }
}
/*
 #Preview {
 profilePic()
 }
 */
