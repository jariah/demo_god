import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    let url: URL?
    let sessionEpoch: Int
    let isMobileView: Bool
    var onURLChange: ((String) -> Void)?

    private static let mobileWidth: CGFloat = 390
    private static let mobileUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"

    func makeNSView(context: Context) -> NSView {
        let container = NSView()
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.black.cgColor
        let webView = createWebView(context: context)
        container.addSubview(webView)
        context.coordinator.currentWebView = webView
        context.coordinator.currentEpoch = sessionEpoch
        context.coordinator.currentMobileView = isMobileView
        applyLayout(webView: webView, container: container)
        loadURL(in: webView)
        return container
    }

    func updateNSView(_ container: NSView, context: Context) {
        if context.coordinator.currentEpoch != sessionEpoch {
            for subview in container.subviews {
                subview.removeFromSuperview()
            }
            let webView = createWebView(context: context)
            container.addSubview(webView)
            context.coordinator.currentWebView = webView
            context.coordinator.currentEpoch = sessionEpoch
            context.coordinator.currentMobileView = isMobileView
            applyLayout(webView: webView, container: container)
            loadURL(in: webView)
        } else if context.coordinator.currentMobileView != isMobileView {
            context.coordinator.currentMobileView = isMobileView
            if let webView = context.coordinator.currentWebView {
                applyLayout(webView: webView, container: container)
            }
        }

        container.layer?.backgroundColor = isMobileView ? NSColor.black.cgColor : NSColor.windowBackgroundColor.cgColor
    }

    private func createWebView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .nonPersistent()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        if isMobileView {
            webView.customUserAgent = Self.mobileUserAgent
        }
        return webView
    }

    private func applyLayout(webView: WKWebView, container: NSView) {
        // Remove all constraints involving the webView
        NSLayoutConstraint.deactivate(
            container.constraints.filter { $0.firstItem === webView || $0.secondItem === webView }
        )
        NSLayoutConstraint.deactivate(
            webView.constraints.filter { $0.firstItem === webView && $0.secondItem == nil }
        )

        if isMobileView {
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.autoresizingMask = []
            NSLayoutConstraint.activate([
                webView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                webView.topAnchor.constraint(equalTo: container.topAnchor),
                webView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                webView.widthAnchor.constraint(equalToConstant: Self.mobileWidth),
            ])
        } else {
            webView.translatesAutoresizingMaskIntoConstraints = true
            webView.frame = container.bounds
            webView.autoresizingMask = [.width, .height]
        }

        container.needsLayout = true
        container.layoutSubtreeIfNeeded()
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
        var currentMobileView: Bool = false
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
