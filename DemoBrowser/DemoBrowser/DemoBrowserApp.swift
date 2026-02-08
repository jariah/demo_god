import SwiftUI

@main
struct DemoBrowserApp: App {
    @State private var store = DemoStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
        .defaultSize(width: 1200, height: 800)
        .commands {
            CommandGroup(after: .sidebar) {
                Button("Toggle Notes") {
                    store.toggleNotesPanel()
                }
                .keyboardShortcut(";", modifiers: .command)

                Button("Refresh Session") {
                    store.refreshSession()
                }
                .keyboardShortcut("r", modifiers: .command)

                Button("Toggle All Chrome") {
                    store.toggleChrome()
                }
                .keyboardShortcut(".", modifiers: [.command, .shift])
            }

            CommandGroup(replacing: .newItem) {
                Button("New Demo") {
                    store.addDemo()
                }
                .keyboardShortcut("n", modifiers: .command)

                Button("Duplicate Demo") {
                    store.duplicateActiveDemo()
                }
                .keyboardShortcut("d", modifiers: .command)
            }
        }
    }
}
