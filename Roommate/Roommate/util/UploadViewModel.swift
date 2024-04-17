//
//  UploadViewModel.swift
//  Roommate
//
//  Created by Spring2024 on 4/15/24.
//

import Foundation

// this offers the ability to upload
class UploadViewModel: NSObject, ObservableObject, URLSessionDelegate, URLSessionDataDelegate {
    
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertInfo: String = ""
    @Published var showUploadAlert: Bool = false
    
    func upload(website: String, user: User) -> Bool {
        let url = URL(string: website)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session : URLSession = {
            let config = URLSessionConfiguration.ephemeral
            config.allowsCellularAccess = false
            let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
            return session
        }()
        
        let encoder = JSONEncoder()
        var jsonData: Data
        do {
            jsonData = try encoder.encode(user)
        } catch {
            return false
        }
        print(String(data: jsonData, encoding: .utf8)!)
        request.httpBody = jsonData
        let task = session.dataTask(with: request)
        task.resume()
        return true
    }
    
    func upload(website: String, json: Data) -> Bool {
        let url = URL(string: website)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let session : URLSession = {
            let config = URLSessionConfiguration.ephemeral
            config.allowsCellularAccess = false
            let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
            return session
        }()
        
//        let encoder = JSONEncoder()
//        var jsonData: Data
//        do {
//            jsonData = try encoder.encode(user)
//        } catch {
//            return false
//        }
//        print(String(data: jsonData, encoding: .utf8)!)
        request.httpBody = json
        let task = session.dataTask(with: request)
        task.resume()
        return true
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            self.alertTitle = "Upload Fail!"
            self.alertInfo = "Please try again!"
            self.showAlert = true
        } else {
            self.alertTitle = "Upload Success!"
            self.alertInfo = "Please download again and check!"
            self.showAlert = true
            print("Upload successfully")
        }
    }
}
