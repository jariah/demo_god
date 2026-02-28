import SwiftUI

struct ContentView: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var glassSettings
    @State private var showGlassSettings = false

    var body: some View {
        BrowserView()
            .onTapGesture {
                if store.isQueueVisible {
                    store.isQueueVisible = false
                }
            }
            .overlay(alignment: .topLeading) {
                if store.isChromeVisible && store.isQueueVisible {
                    DemoQueueView()
                        .frame(width: 280)
                        .background {
                            Rectangle()
                                .fill(.thickMaterial)
                                .overlay {
                                    Rectangle()
                                        .fill(.black.opacity(0.75))
                                }
                        }
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 1)
                        }
                        .transition(.move(edge: .leading).combined(with: .opacity))
                        .environment(\.colorScheme, .dark)
                }
            }
            .overlay(alignment: .topTrailing) {
                if store.isNotesPanelVisible {
                    NotesPanel()
                        .frame(width: 280)
                        .background {
                            Rectangle()
                                .fill(.thickMaterial)
                                .overlay {
                                    Rectangle()
                                        .fill(.black.opacity(0.75))
                                }
                        }
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(.white.opacity(0.1))
                                .frame(width: 1)
                        }
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                        .environment(\.colorScheme, .dark)
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
            .animation(.spring(duration: 0.3), value: store.isQueueVisible)
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
