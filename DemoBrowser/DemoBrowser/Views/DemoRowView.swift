import SwiftUI

struct DemoRowView: View {
    @Environment(DemoStore.self) private var store
    let demo: Demo
    let isQueueEditing: Bool

    @State private var editingName: String = ""
    @State private var editingURL: String = ""
    @FocusState private var nameFieldFocused: Bool

    private var isNewlyCreated: Bool {
        store.editingDemoID == demo.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if isQueueEditing || isNewlyCreated {
                TextField("Name", text: $editingName)
                    .textFieldStyle(.plain)
                    .font(.body)
                    .focused($nameFieldFocused)
                    .onChange(of: editingName) { _, newValue in
                        store.updateDemoName(demo.id, name: newValue)
                    }

                TextField("URL", text: $editingURL)
                    .textFieldStyle(.plain)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .onChange(of: editingURL) { _, newValue in
                        store.updateDemoURL(demo.id, url: newValue)
                    }
            } else {
                Text(demo.name)
                    .font(.body)
                    .lineLimit(1)
                Text(demo.url)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 2)
        .onAppear {
            editingName = demo.name
            editingURL = demo.url
            if isNewlyCreated {
                nameFieldFocused = true
            }
        }
        .onChange(of: isQueueEditing) { _, editing in
            if editing {
                editingName = demo.name
                editingURL = demo.url
            }
        }
        .onChange(of: isNewlyCreated) { _, newValue in
            if newValue {
                editingName = demo.name
                editingURL = demo.url
                nameFieldFocused = true
            }
        }
    }
}
