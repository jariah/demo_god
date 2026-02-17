import SwiftUI

struct BrowserView: View {
    @Environment(DemoStore.self) private var store

    var body: some View {
        WebView(
            url: URL(string: store.currentDisplayURL),
            sessionEpoch: store.sessionEpoch,
            isMobileView: store.activeDemoIsMobileView,
            onURLChange: { newURL in
                store.updateCurrentDisplayURL(newURL)
            }
        )
    }
}
