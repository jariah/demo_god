import SwiftUI

struct NotesPanel: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var glassSettings

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Notes")
                    .font(.headline)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Divider()

            if let demo = store.activeDemo {
                TextEditor(text: Binding(
                    get: { demo.notes },
                    set: { store.updateNotes($0) }
                ))
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.primary.opacity(glassSettings.notesTextOpacity))
                .scrollContentBackground(.hidden)
                .padding(12)
            } else {
                ContentUnavailableView(
                    "No Demo Selected",
                    systemImage: "doc.text",
                    description: Text("Select a demo to view notes")
                )
            }
        }
    }
}
