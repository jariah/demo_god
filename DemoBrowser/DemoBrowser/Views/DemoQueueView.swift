import SwiftUI

struct DemoQueueView: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var gs
    @State private var isEditing: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Demos")
                    .font(.headline)
                    .foregroundStyle(gs.resolveColor(gs.queueHeaderColor, opacity: gs.queueHeaderOpacity))
                Spacer()
                Button(action: {
                    isEditing.toggle()
                    if !isEditing {
                        store.editingDemoID = nil
                    }
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .foregroundStyle(gs.resolveColor(gs.queueHeaderButtonColor, opacity: gs.queueHeaderButtonOpacity))
                }
                .buttonStyle(.borderless)

                Button(action: {
                    store.addDemo()
                }) {
                    Image(systemName: "plus")
                        .foregroundStyle(gs.resolveColor(gs.queueHeaderButtonColor, opacity: gs.queueHeaderButtonOpacity))
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider()
                .overlay(gs.resolveColor(gs.queueDividerColor, opacity: gs.queueDividerOpacity))

            List(selection: Binding(
                get: { store.activeDemoID },
                set: { newID in
                    if let id = newID, let demo = store.demos.first(where: { $0.id == id }) {
                        store.selectDemo(demo)
                    }
                }
            )) {
                ForEach(store.demos) { demo in
                    let isSelected = store.activeDemoID == demo.id
                    DemoRowView(demo: demo, isQueueEditing: isEditing)
                        .tag(demo.id)
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(isSelected
                                    ? gs.resolveColor(gs.queueRowSelectedBgColor, opacity: gs.queueRowSelectedBgOpacity)
                                    : gs.resolveColor(gs.queueRowNormalBgColor, opacity: gs.queueRowNormalBgOpacity))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                        )
                        .listRowSeparator(.hidden)
                }
                .onMove { source, destination in
                    store.moveDemos(from: source, to: destination)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }
}
