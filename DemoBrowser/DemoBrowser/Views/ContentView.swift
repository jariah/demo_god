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
        .alert("Delete Demo", isPresented: Binding(
            get: { store.showDeleteConfirmation },
            set: { store.showDeleteConfirmation = $0 }
        )) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                store.deleteActiveDemo()
            }
        } message: {
            if let name = store.activeDemo?.name {
                Text("Are you sure you want to delete \"\(name)\"?")
            }
        }
    }
}
