//
//  ContentView.swift
//  Roommate
//
//  Created by Spring2024 on 3/15/24.
//

import SwiftUI
import ECE564Login

class DownloadManager: NSObject, ObservableObject, URLSessionDownloadDelegate{
    
    //hold download task
    private var task: URLSessionDownloadTask?
    //completion handler returning if downloaded correct or not
    var downloadingCompletionHandler: (([User]) -> Bool)?
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if let error = error{
            print("Download failed with error \(error.localizedDescription)")
        }
        else{
            print("Download successfully")
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download completed. File saved at: \(location.absoluteString)")
        do{
            let data = try Data(contentsOf: location)
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyPrintedData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
               let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8) {
                print(prettyPrintedString)
            }
            
            //do{
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([User].self, from: data)
                // If decoding is successful, use 'decoded' data
            } catch {
                print("Decoding error: \(error)")
            }
           //}
        }catch{
            print("error retrieving data ")
        }
    }
    func download(website: String, auth: String, delegate: URLSessionDelegate?) -> Bool{
        guard let url = URL(string: website)else{
            return false
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        ///credentials
        let credentials =  "vcm:\(auth)"
        guard let authData = credentials.data(using: .utf8) else{
            return false
        }
        let base64Auth = authData.base64EncodedString()
        request.addValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session: URLSession
        if let delegate = delegate{
            let config = URLSessionConfiguration.default
            session = URLSession(configuration: config, delegate: delegate, delegateQueue: .main)
        }else{
            session = URLSession.shared
        }
        
        task = session.downloadTask(with: request)
        task?.resume()
        return true
                
    }
    func downloadData(completionHandler: (([User]) -> Bool)?){
        self.downloadingCompletionHandler = completionHandler
        let url = "http://vcm-39030.vm.duke.edu:8080/roommate/list"
        let authentication = "imgrople8U"
        _ = download(website: url, auth: authentication, delegate: self)
    }
}
 

struct ContentView: View {
    @ObservedObject var dataModel: Database  = Database.shared
    @StateObject private var downloadManager = DownloadManager()
    @State private var currentNetID: String = ""
    @State private var isViewVisible: Bool = false
        //immediate downlod
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
            ECE564Login()
        }
        .onAppear{
            downloadManager.downloadData(completionHandler: dataModel.replaceDB)
        }
    }
        
}

#Preview {
    ContentView()
}
