import SwiftUI

struct DemoRowView: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var gs
    let demo: Demo
    let isQueueEditing: Bool

    @State private var editingName: String = ""
    @State private var editingURL: String = ""
    @FocusState private var nameFieldFocused: Bool

    private var isNewlyCreated: Bool {
        store.editingDemoID == demo.id
    }

    private var isSelected: Bool {
        store.activeDemoID == demo.id
    }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                if isQueueEditing || isNewlyCreated {
                    TextField("Name", text: $editingName)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                        .focused($nameFieldFocused)
                        .onChange(of: editingName) { _, newValue in
                            store.updateDemoName(demo.id, name: newValue)
                        }

                    TextField("URL", text: $editingURL)
                        .textFieldStyle(.roundedBorder)
                        .font(.subheadline)
                        .onChange(of: editingURL) { _, newValue in
                            store.updateDemoURL(demo.id, url: newValue)
                        }
                } else {
                    Text(demo.name)
                        .font(.body)
                        .foregroundStyle(isSelected
                            ? gs.resolveColor(gs.queueRowSelectedNameColor, opacity: gs.queueRowSelectedNameOpacity)
                            : gs.resolveColor(gs.queueRowNormalNameColor, opacity: gs.queueRowNormalNameOpacity))
                        .lineLimit(1)
                    Text(demo.url)
                        .font(.subheadline)
                        .foregroundStyle(isSelected
                            ? gs.resolveColor(gs.queueRowSelectedURLColor, opacity: gs.queueRowSelectedURLOpacity)
                            : gs.resolveColor(gs.queueRowNormalURLColor, opacity: gs.queueRowNormalURLOpacity))
                        .lineLimit(1)
                }
            }

            Spacer()

            Toggle(isOn: Binding(
                get: { demo.isMobileView },
                set: { _ in store.toggleMobileView(for: demo.id) }
            )) {
                Image(systemName: demo.isMobileView ? "iphone" : "desktopcomputer")
                    .font(.caption)
                    .foregroundStyle(isSelected
                        ? gs.resolveColor(gs.queueRowSelectedURLColor, opacity: gs.queueRowSelectedURLOpacity)
                        : gs.resolveColor(gs.queueRowNormalURLColor, opacity: gs.queueRowNormalURLOpacity))
            }
            .toggleStyle(.switch)
            .controlSize(.mini)
            .labelsHidden()
        }
        .padding(.vertical, 4)
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
