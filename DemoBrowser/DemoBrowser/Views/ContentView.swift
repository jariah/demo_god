import SwiftUI

struct ContentView: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var glassSettings
    @State private var showGlassSettings = false

    var body: some View {
        BrowserView()
            .overlay(alignment: .top) {
                if store.isChromeVisible {
                    AddressBar()
                        .padding(.top, 12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .overlay(alignment: .topLeading) {
                if store.isChromeVisible {
                    DemoQueueView()
                        .frame(width: 260)
                        .glassEffect(
                            glassSettings.queueGlass,
                            in: RoundedRectangle(cornerRadius: glassSettings.queueCornerRadius)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 16, y: 4)
                        .padding(.top, 56)
                        .padding(.leading, 12)
                        .padding(.bottom, 12)
                        .transition(.move(edge: .leading).combined(with: .opacity))
                        .environment(\.colorScheme, glassSettings.queueForceDark ? .dark : .light)
                }
            }
            .overlay(alignment: .topTrailing) {
                if store.isChromeVisible && store.isNotesPanelVisible {
                    NotesPanel()
                        .frame(width: 300)
                        .glassEffect(
                            glassSettings.notesGlass,
                            in: RoundedRectangle(cornerRadius: glassSettings.notesCornerRadius)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 16, y: 4)
                        .padding(.top, 56)
                        .padding(.trailing, 12)
                        .padding(.bottom, 12)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .environment(\.colorScheme, glassSettings.notesForceDark ? .dark : .light)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if showGlassSettings {
                    GlassSettingsPanel()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.3), radius: 20, y: 8)
                        .padding(.trailing, 12)
                        .padding(.bottom, 12)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .animation(.spring(duration: 0.3), value: store.isChromeVisible)
            .animation(.spring(duration: 0.3), value: store.isNotesPanelVisible)
            .animation(.spring(duration: 0.3), value: showGlassSettings)
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
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ToggleGlassSettings"))) { _ in
                showGlassSettings.toggle()
            }
    }
}
