import SwiftUI

struct NotesPanel: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var glassSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("NOTES")
                    .font(.system(size: 16, weight: .bold))
                    .tracking(1.44)
                    .foregroundStyle(.primary)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            if let demo = store.activeDemo {
                TextEditor(text: Binding(
                    get: { demo.notes },
                    set: { store.updateNotes($0) }
                ))
                .font(.system(size: 16))
                .foregroundStyle(.primary)
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
