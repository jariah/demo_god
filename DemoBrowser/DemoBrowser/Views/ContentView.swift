import SwiftUI

struct ContentView: View {
    @Environment(DemoStore.self) private var store

    var body: some View {
        HStack(spacing: 0) {
            if store.isChromeVisible {
                DemoQueueView()
                    .frame(width: 220)

                Divider()
            }

            BrowserView()

            if store.isChromeVisible && store.isNotesPanelVisible {
                Divider()

                NotesPanel()
                    .frame(width: 280)
            }
        }
        .frame(minWidth: 800, minHeight: 500)
    }
}
