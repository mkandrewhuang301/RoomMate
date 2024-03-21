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
    var height: Double = 20
    var width: Double = 20
    @State var user: User = User()
    init(){
        
    }
    var body: some View {
        VStack{
            //profilePic(height:height, width: width)
        }
        .onAppear{
            netID = UserDefaults.standard.string(forKey: "AuthString")!.components(separatedBy: ":")[0]
            password = UserDefaults.standard.string(forKey: "AuthString")!.components(separatedBy: ":")[1]
            
            DownloadManager<User>().downloadData(url: "http://vcm-39030.vm.duke.edu:8080/roommate/user/\(netID)"){ result in
                switch result{
                case .failure(let error):
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

#Preview {
    ProfileView()
}
