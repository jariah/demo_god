import SwiftUI

struct NotesPanel: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var glassSettings
    @State private var isPanelHovered: Bool = false
    @FocusState private var isEditorFocused: Bool

    private var textBrightness: Double {
        (isPanelHovered || isEditorFocused) ? 0.85 : 0.45
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header matching DEMOGOD branding on left panel
            HStack {
                Text("NOTES")
                    .font(.system(size: 13, weight: .bold))
                    .tracking(3)
                    .foregroundStyle(.white)

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)

            Rectangle()
                .fill(.white.opacity(0.08))
                .frame(height: 1)

            if let demo = store.activeDemo {
                TextEditor(text: Binding(
                    get: { demo.notes },
                    set: { store.updateNotes($0) }
                ))
                .font(.system(size: 13, design: .monospaced))
                .lineSpacing(6)
                .foregroundStyle(.white.opacity(textBrightness))
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .focused($isEditorFocused)
                .animation(.easeInOut(duration: 0.2), value: textBrightness)
            } else {
                VStack {
                    Spacer()
                    Text("No demo selected")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.2))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }

            HStack {
                Spacer()
                Text("\u{2318}; to dismiss")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.3))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
        }
        .onHover { hovering in
            isPanelHovered = hovering
        }
    }
}
