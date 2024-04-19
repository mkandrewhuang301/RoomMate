//
//  DataManager.swift
//  Roommate
//
//  Created by Andrew Huang on 4/4/24.
//

import Foundation

// this offers the ability to download
class DownloadManager<T: Decodable>: NSObject, ObservableObject, URLSessionDownloadDelegate{
    
    //hold download task
    private var task: URLSessionDownloadTask?
    //completion handler provide task for downloading
    var downloadingCompletionHandler: ((Result<T, Error>)  -> Bool)?
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
        if let error = error{
            print("Download failed with error \(error.localizedDescription)")
            DispatchQueue.main.async {
                let _ = self.downloadingCompletionHandler?(.failure(error))
            }
        }
        else{
            print("Download successfully")
        }
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download completed. File saved at: \(location.absoluteString)")
        do{
            let data = try Data(contentsOf: location)
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                   let _ = self.downloadingCompletionHandler?(.success(decoded))
               }
            } catch {
                print("Decoding error: \(error)")
            }
        }catch{
            print("error retrieving data ")
            DispatchQueue.main.async {
                let _ = self.downloadingCompletionHandler?(.failure(error))
            }
        }
    }
    func download(website: String, auth: String, delegate: URLSessionDelegate?) -> Bool{
        guard let url = URL(string: website)else{
            return false
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
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
    func downloadData(url: String, completionHandler: ( (Result<T, Error>) -> Bool)?){
        self.downloadingCompletionHandler = completionHandler
        let authentication = "imgrople8U"
        _ = download(website: url, auth: authentication, delegate: self)
    }
}
