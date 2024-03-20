//
//  ContentView.swift
//  Roommate
//
//  Created by Spring2024 on 3/15/24.
//

import SwiftUI
import ECE564Login

struct ContentView: View {
    @StateObject var dataModel: Database  = Database.shared
    
    var body: some View {
        ZStack {
            TabView{
                VStack{
                    Text("Hello everyone")
                }
                .tabItem{
                    Label("", systemImage:"circle.hexagongrid.circle.fill")
                }
                
                
                NavigationView{
                    BlogView()
                }
                .tabItem{
                    Label("", systemImage:"house")
                }
                
                
                NavigationView{
                    ChatView()
                }
                .tabItem {
                    Label("", systemImage: "message.fill")
                }
                
                
                
                NavigationView{
                    ProfileView()
                }
                .tabItem {
                    Label("", systemImage: "person.fill")
                }
                
            }
            //ECE564Login()
        }
    }
        
}

#Preview {
    ContentView()
}
