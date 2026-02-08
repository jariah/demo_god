import SwiftUI

struct NotesPanel: View {
    @Environment(DemoStore.self) private var store

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Notes")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            Divider()

            if let demo = store.activeDemo {
                TextEditor(text: Binding(
                    get: { demo.notes },
                    set: { store.updateNotes($0) }
                ))
                .font(.system(.body, design: .monospaced))
                .scrollContentBackground(.hidden)
                .padding(8)
            } else {
                VStack {
                    Spacer()
                    Text("Select a demo to view notes")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
        }
    }
}
