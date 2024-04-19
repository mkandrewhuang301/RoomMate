//
//  Database.swift
//  Roommate
//
//  Created by Andrew Huang on 3/19/24.
//



import Foundation
import SwiftUI
import WebKit

class WebViewData: NSObject, ObservableObject {
    @Published var pageTitles: [String]
    var urls: [URL]
    
    init(urls: [URL]) {
        self.urls = urls
        self.pageTitles = Array(repeating: "Loading...", count: urls.count)
        super.init()
    }
}
///second webview for the preview that users see when they click on the specific link
struct WebView2: UIViewRepresentable {
    @ObservedObject var webViewData: WebViewData
    var index: Int

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isUserInteractionEnabled = false
        webView.scrollView.isScrollEnabled = false
        //webView.configuration.preferences.javaScriptEnabled = true
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: webViewData.urls[index])
        if uiView.url != webViewData.urls[index] {
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView2
        var hasLoaded = false

        init(_ parent: WebView2) {
            self.parent = parent
        }
        //utilized copilot for webView (to get the link titles)
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if !hasLoaded {
                webView.evaluateJavaScript("document.title") { result, error in
                    if let title = result as? String {
                        DispatchQueue.main.async {
                            self.parent.webViewData.pageTitles[self.parent.index] = title
                        }
                    }
                }
                hasLoaded = true
            }
        }
    }
}
struct WebView: UIViewRepresentable { // First webview for the preview of the website
    @ObservedObject var webViewData: WebViewData
    var index: Int

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        //webView.configuration.preferences.javaScriptEnabled = true
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: webViewData.urls[index])
        if uiView.url != webViewData.urls[index] {
            uiView.load(request)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var hasLoaded = false

        init(_ parent: WebView) {
            self.parent = parent
        }
        //utilized copilot for webView (to get the link titles)
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if !hasLoaded {
                webView.evaluateJavaScript("document.title") { result, error in
                    if let title = result as? String {
                        DispatchQueue.main.async {
                            self.parent.webViewData.pageTitles[self.parent.index] = title
                        }
                    }
                }
                hasLoaded = true
            }
        }
    }
}


struct FormatView: View {
    @ObservedObject var webViewData: WebViewData
    var index: Int
    
    var body: some View {
        WebView(webViewData: webViewData, index: index)
            .navigationBarTitle(Text(webViewData.pageTitles[index]), displayMode: .inline)
    }
}

struct BlogView: View {
    @StateObject var webViewData = WebViewData(urls: [
       URL(string: "https://www.nyc.gov/site/specialenforcement/registration-law/tips-for-hosts.page")!,
       URL(string: "https://www.azibo.com/blog/short-term-rentals-in-new-york-city")!,
       URL(string: "https://bungalow.com/articles/best-neighborhoods-in-new-york-city-new-york")!,
       URL(string: "https://realestate.usnews.com/places/rankings/best-places-to-live")!,
       URL(string: "https://money.com/best-places-to-live/")!,
       URL(string: "https://www.livebrizo.com/?utm_source=google&utm_medium=cpc&utm_campaign=search&utm_term=durham%20apartments&utm_content=location&gad_source=1&gclid=CjwKCAjw_e2wBhAEEiwAyFFFo_E0_UUtBACsOMTjFVltGWsr_VfJEd0rdOXKsTETDRa1XXtVL9hEQRoCLd8QAvD_BwE")!
    ])
    @State var searchText = ""
    var filteredIndices: [Int] {
        guard !searchText.isEmpty else{
            return Array(webViewData.urls.indices)
        }
        return webViewData.pageTitles.enumerated().compactMap{ index, title in
            title.lowercased().contains(searchText.lowercased()) ? index : nil
        }
    }
    var body: some View {
        NavigationView {
            List(filteredIndices, id: \.self) { index in
                NavigationLink(destination: FormatView(webViewData: webViewData, index: index)) {
                    VStack(alignment: .leading) {
                        WebView2(webViewData: webViewData, index: index)
                            .frame(height: 250)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        Text(webViewData.pageTitles[index])
                            .bold()
                    }
                }
                .padding()
            }
            .navigationBarTitle("Housing Articles")
        }
        .searchable(text: $searchText, prompt: "Search for a Blog...") {}
    }
}
