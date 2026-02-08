import SwiftUI

struct BrowserView: View {
    @Environment(DemoStore.self) private var store

    var body: some View {
        VStack(spacing: 0) {
            if store.isChromeVisible {
                AddressBar()
                Divider()
            }

            WebView(
                url: URL(string: store.currentDisplayURL),
                sessionEpoch: store.sessionEpoch,
                onURLChange: { newURL in
                    store.updateCurrentDisplayURL(newURL)
                }
            )
        }
    }
}
