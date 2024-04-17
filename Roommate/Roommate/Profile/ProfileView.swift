//
//  ProfileView.swift
//  Roommate
//
//  Created by Andrew Huang on 3/19/24.
//
/*
 1. create vstack
 2. add image. If not there, then set to default image
 3. add view to display circle for progress, and navigation link for setting
 3. add list of information
 need to store the correct UUID
 How to get the right UUID??? when initializing, if userdefaults UUID is empty, then generate and add one to it.
        - create new instance and add to database
 
 */
import SwiftUI

// this is the profile view
struct ProfileView: View {
    @StateObject var dataModel: Database  = Database.shared
    @State private var netID: String = ""
    @State private var password: String = ""
    @State var isLoading: Bool = true
    var height: Double = 125
    var width: Double = 125
    @Binding var user: User
    var percent: Double {
        let total: Double = 17.0 ///number of variables needed to be set in USER
        var count = 0.0
        if(user.DUID != 0){
            count+=1
        }
        if(user.netId != ""){
            count+=1
        }
        if(user.fName != "Unknown"){
            count+=1
        }
        if(user.lName != "Unknown"){
            count+=1
        }
        if(user.gender != .Unknown){
            count+=1
        }
        if(user.purpose != .Unknown){
            count+=1
        }
        if(!user.photos.isEmpty){
            count+=1
        }
        if(user.school != .NotApplicable){
            count+=1
        }
        //self.program = program ?? .NotApplicable
        if(user.major != .NotApplicable){
            count+=1
        }
        if(user.gradYear != 0){
            count+=1
        }
        if(!(user.sleepSchedule.min ==  0 && user.sleepSchedule.max == 0)){
            count+=1
        }
        if(!(user.budget.min ==  0 && user.budget.max == 0)){
            count+=1
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
        }
        ///ROOM IS OPTIONAL
        //self.room = room ?? Room()
        
        ///need number of elements  in  Preferences
        //Get preference elements
        if(user.preference.gender != .Unknown){
            count+=1
        }
        if(!(user.preference.ageRange.min ==  0 && user.preference.ageRange.max == 0)){
            count+=1
        }
        
        if(user.location != ""){
            count+=1
        }
        if(!user.interests.isEmpty){
            count+=1
        }
        print(count)
        return count / total
        /*
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            percent = count / total
        }
         */

    }
    @State var showOverlay: Bool = false
   
    var body: some View {
        VStack{
//            NavigationLink(destination: editProfileView(user: $user)){
            HStack(spacing: 0) {
                Spacer()
                Image("iconimage")
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("RoomMate")
                    .font(.custom("Futura", size: 28))
                    .bold()
                    .foregroundStyle(Color.accentColor)
                    .frame(height: 50)
                Spacer()
            }
            .padding()
            .frame(height: 80)
            Button(action: {
                withAnimation {
                    showOverlay = true
                }
            }){
                VStack{
                    switch isLoading{
                    case false:
                        profilePic(photo: (user.photos.isEmpty ? "" :  user.photos[0] ), user: $user, height: height, width: width, percent: percent )
                            .offset(y:42)
                    case true:
                        profilePic(photo: (user.photos.isEmpty ? "" :  user.photos[0] ), user: $user, height: height, width: width, percent: percent)
                            .offset(y:42)
                    }
                    
                    ZStack{
                        Color(red: 0.95, green: 0.95, blue: 0.95)
                            .frame(width:34, height:34)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        
                        Image(systemName:"pencil")
                            .resizable()
                            .foregroundColor(.gray)
                        
                            .frame(width:23, height:23)
                    }
                    
                    .frame(width:33, height:34)
                    .offset(x:50, y: -145)
                }
           }
            VStack{
                Text("\(user.fName) \(user.lName), \(user.age)")
                //.offset(y:-40)
                    .padding(.vertical, 5)
                    .font(.custom("Helvetica Neue", size: 24))
                    .fontWeight(.heavy)
                if(percent != 1){
                    Text("Incomplete Profile")
                        .font(.custom("Helvetica Neue", size: 16))
                        .italic()
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                }
            }
            .offset(y: -35)
            Divider()
            ///Could make scrollview
            HStack(spacing: 0) {
                Image("roommates")
                    .resizable()
                    
                Divider()

                Image("roommates2")
                    .resizable()
                    
            }
            .scaledToFit()
            
            Spacer()
            
//            helpButton()
//                .padding()
        }
        .onAppear{
//            isLoading = true
//            netID = UserDefaults.standard.string(forKey: "AuthString")!.components(separatedBy: ":")[0]
//            password = UserDefaults.standard.string(forKey: "AuthString")!.components(separatedBy: ":")[1]
//            DownloadManager<User>().downloadData(url: "http://vcm-39030.vm.duke.edu:8080/roommate/user/\(netID)"){ result in
//                isLoading = false
//                switch result{
//                    //when user not found, just use new profile
//                    case .failure( _):
//                        self.user = User()
//                        return true
//                    case .success(let user):
//                        self.user = user
//                        return true
//                }
//            }
        }
        .fullScreenCover(isPresented: $showOverlay) {
            ProfileEditTabView(user: $user, showOverlay: $showOverlay)
        }
    }
        
}

struct helpButton: View {
    var body: some View {
        HStack{
            Image(systemName:"questionmark.circle")
            Text("Help")
                .foregroundColor(.white)
        }
        .padding()
        //.cornerRadius(40)
        .background(Color(red: 0.667, green: 0.667, blue: 0.667))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        
    }
}

//
// #Preview {
// ProfileView()
// }
 
