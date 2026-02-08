import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL?
    let sessionEpoch: Int
    var onURLChange: ((String) -> Void)?

    func makeNSView(context: Context) -> NSView {
        let container = NSView()
        let webView = createWebView(context: context)
        webView.frame = container.bounds
        webView.autoresizingMask = [.width, .height]
        container.addSubview(webView)
        context.coordinator.currentWebView = webView
        context.coordinator.currentEpoch = sessionEpoch
        loadURL(in: webView)
        return container
    }

    func updateNSView(_ container: NSView, context: Context) {
        if context.coordinator.currentEpoch != sessionEpoch {
            // Session changed — destroy old WebView, create fresh one
            for subview in container.subviews {
                subview.removeFromSuperview()
            }
            let webView = createWebView(context: context)
            webView.frame = container.bounds
            webView.autoresizingMask = [.width, .height]
            container.addSubview(webView)
            context.coordinator.currentWebView = webView
            context.coordinator.currentEpoch = sessionEpoch
            loadURL(in: webView)
        }
    }

    private func createWebView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }

    private func loadURL(in webView: WKWebView) {
        guard let url else { return }
        webView.load(URLRequest(url: url))
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onURLChange: onURLChange)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var currentWebView: WKWebView?
        var currentEpoch: Int = -1
        var onURLChange: ((String) -> Void)?

        init(onURLChange: ((String) -> Void)?) {
            self.onURLChange = onURLChange
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString {
                onURLChange?(url)
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString {
                onURLChange?(url)
            }
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            if let url = webView.url?.absoluteString {
                onURLChange?(url)
            }
        }
    }
}
