import SwiftUI

@main
struct DemoBrowserApp: App {
    @State private var store = DemoStore()
    @State private var glassSettings = GlassSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
                .environment(glassSettings)
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

                Divider()

                Button("Toggle Glass Settings") {
                    NotificationCenter.default.post(name: NSNotification.Name("ToggleGlassSettings"), object: nil)
                }
                .keyboardShortcut("g", modifiers: [.command, .shift])
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

                Divider()

                Button("Delete Demo") {
                    store.showDeleteConfirmation = true
                }
                .keyboardShortcut("w", modifiers: .command)
                .disabled(store.activeDemo == nil)
            }
        }
    }
}
