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

struct ProfileView: View {
    @StateObject var dataModel: Database  = Database.shared
    @State private var netID: String = ""
    @State private var password: String = ""
    @State var isLoading: Bool = true
    var height: Double = 125
    var width: Double = 125
    @State var user: User = User()
    init(){
        
    }
    var body: some View {
        VStack{
            switch isLoading{
                case false:
                    profilePic(photo: (user.photos.isEmpty ? "" :  user.photos[0] ), user: user, height: height, width: width)
                        .offset(y:45)
                case true:
                    profilePic(photo: (user.photos.isEmpty ? "" :  user.photos[0] ), user: user, height: height, width: width)
                        .offset(y:45)
            }
            ZStack{
                Color(red: 0.95, green: 0.95, blue: 0.95)
                    .frame(width:34, height:34)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                NavigationLink(destination: editProfileView()){
                    Image(systemName:"pencil")
                        .resizable()
                        .foregroundColor(.gray)
                }
                    .frame(width:23, height:23)
            }
                .frame(width:33, height:34)
                .offset(x:50, y: -145)
            Spacer()
        }
        .onAppear{
            isLoading = true
            netID = UserDefaults.standard.string(forKey: "AuthString")!.components(separatedBy: ":")[0]
            password = UserDefaults.standard.string(forKey: "AuthString")!.components(separatedBy: ":")[1]
            
            DownloadManager<User>().downloadData(url: "http://vcm-39030.vm.duke.edu:8080/roommate/user/\(netID)"){ result in
                isLoading = false
                switch result{
                    //when user not found, just use new profile
                    case .failure( _):
                        self.user = User()
                        return true
                    case .success(let user):
                        self.user = user
                        return true
                }

            }
        }
    }
        
}

/*
 #Preview {
 ProfileView()
 }
 */
