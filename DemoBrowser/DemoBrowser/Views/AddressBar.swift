import SwiftUI

struct AddressBar: View {
    @Environment(DemoStore.self) private var store
    @State private var editingURL: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "globe")
                .foregroundStyle(.secondary)

            TextField("Enter URL", text: $editingURL, onEditingChanged: { editing in
                if editing {
                    isEditing = true
                }
            })
            .textFieldStyle(.plain)
            .font(.system(.body, design: .monospaced))
            .focused($isFocused)
            .onSubmit {
                store.navigateTo(editingURL)
                isEditing = false
                isFocused = false
            }
            .onChange(of: store.currentDisplayURL) { _, newValue in
                if !isEditing {
                    editingURL = newValue
                }
            }
            .onAppear {
                editingURL = store.currentDisplayURL
            }

            Button(action: { store.isMobileView.toggle() }) {
                Image(systemName: store.isMobileView ? "iphone" : "desktopcomputer")
                    .foregroundStyle(store.isMobileView ? Color.accentColor : Color.secondary)
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.bar)
    }
}
