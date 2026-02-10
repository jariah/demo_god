import SwiftUI

struct DemoQueueView: View {
    @Environment(DemoStore.self) private var store
    @State private var isEditing: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Demo Queue")
                    .font(.headline)
                Spacer()
                Button(action: {
                    isEditing.toggle()
                    if !isEditing {
                        store.editingDemoID = nil
                    }
                }) {
                    Text(isEditing ? "Done" : "Edit")
                        .font(.caption)
                }
                .buttonStyle(.borderless)

                Button(action: {
                    store.addDemo()
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            if isEditing {
                List {
                    ForEach(store.demos) { demo in
                        DemoRowView(demo: demo, isQueueEditing: true)
                    }
                    .onMove { source, destination in
                        store.moveDemos(from: source, to: destination)
                    }
                }
                .listStyle(.sidebar)
            } else {
                List(selection: Binding(
                    get: { store.activeDemoID },
                    set: { newID in
                        if let id = newID, let demo = store.demos.first(where: { $0.id == id }) {
                            store.selectDemo(demo)
                        }
                    }
                )) {
                    ForEach(store.demos) { demo in
                        DemoRowView(demo: demo, isQueueEditing: false)
                            .tag(demo.id)
                    }
                    .onMove { source, destination in
                        store.moveDemos(from: source, to: destination)
                    }
                }
                .listStyle(.sidebar)
            }
        }
    }
}
