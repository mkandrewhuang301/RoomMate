//
//  Database.swift
//  Roommate
//
//  Created by Andrew Huang on 3/19/24.
//



import SwiftUI
import WebKit

struct WebView: UIViewRepresentable{
    //Below function is for displaying the views once I click on them
    var url: URL
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        //webView.scrollView.isScrollEnabled = false
        //webView.isUserInteractionEnabled = false
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
struct formatView: View {
    var url: URL
    @State private var pageTitle: String = "Loading..."
    var body: some View {
        WebView(url: url)
            .navigationBarTitle("Website", displayMode: .inline)
    }
}
struct BlogView: View {
    let links = [
        "t",
        "https://www.azibo.com/blog/short-term-rentals-in-new-york-city",
        "https://bungalow.com/articles/best-neighborhoods-in-new-york-city-new-york",
        "https://realestate.usnews.com/places/rankings/best-places-to-live",
        "https://money.com/best-places-to-live/",
        "https://www.livebrizo.com/?utm_source=google&utm_medium=cpc&utm_campaign=search&utm_term=durham%20apartments&utm_content=location&gad_source=1&gclid=CjwKCAjw_e2wBhAEEiwAyFFFo_E0_UUtBACsOMTjFVltGWsr_VfJEd0rdOXKsTETDRa1XXtVL9hEQRoCLd8QAvD_BwE"
    ]
    var body: some View {
        NavigationView {
            List(links, id: \.self) { link in
                if let url = URL(string: link) {
                    NavigationLink(destination: formatView(url: url)) {
                        //ZStack{
                            Text(url.host ?? "Unknown URL")
                            WebView(url: url)
                                .frame(height: 100)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                       // }
                        
                    }
                }
            }
            .navigationBarTitle("Housing articles")
        }
    }
}
