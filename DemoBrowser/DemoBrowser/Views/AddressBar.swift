import SwiftUI

struct AddressBar: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var glassSettings
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
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .frame(minWidth: 300, maxWidth: 600)
        .glassEffect(
            glassSettings.addressBarGlass,
            in: RoundedRectangle(cornerRadius: glassSettings.addressBarCornerRadius)
        )
        .shadow(color: .black.opacity(0.15), radius: 8, y: 2)
        .environment(\.colorScheme, glassSettings.addressBarForceDark ? .dark : .light)
    }
}
