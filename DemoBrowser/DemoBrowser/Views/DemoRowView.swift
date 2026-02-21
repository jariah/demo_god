import SwiftUI

struct DemoRowView: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var gs
    let demo: Demo

    @State private var editingName: String = ""
    @State private var editingURL: String = ""
    @State private var isEditingTitle: Bool = false
    @State private var isHovering: Bool = false
    @FocusState private var nameFieldFocused: Bool
    @FocusState private var urlFieldFocused: Bool

    private var isNewlyCreated: Bool {
        store.editingDemoID == demo.id
    }

    private var isSelected: Bool {
        store.activeDemoID == demo.id
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if isSelected {
                selectedView
                    .transition(.opacity.combined(with: .scale(scale: 0.97, anchor: .topLeading)))
            } else {
                unselectedView
                    .transition(.opacity)
            }
        }
        .padding(.vertical, isSelected ? 10 : 4)
        .padding(.horizontal, isSelected ? 6 : 0)
        .glassEffect(
            isSelected ? .regular : .identity,
            in: RoundedRectangle(cornerRadius: 8)
        )
        .shadow(
            color: isSelected ? .black.opacity(0.25) : .clear,
            radius: 6.5, y: 4
        )
        .animation(.easeInOut(duration: 0.25), value: isSelected)
        .onAppear {
            editingName = demo.name
            editingURL = demo.url
            if isNewlyCreated {
                isEditingTitle = true
                nameFieldFocused = true
            }
        }
        .onChange(of: isNewlyCreated) { _, newValue in
            if newValue {
                editingName = demo.name
                editingURL = demo.url
                isEditingTitle = true
                nameFieldFocused = true
            }
        }
        .onChange(of: isSelected) { _, selected in
            if !selected {
                isEditingTitle = false
            }
        }
    }

    // MARK: - Selected State

    @ViewBuilder
    private var selectedView: some View {
        HStack(alignment: .top) {
            if isEditingTitle {
                TextField("Name", text: $editingName, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.primary)
                    .focused($nameFieldFocused)
                    .lineLimit(1...3)
                    .fixedSize(horizontal: false, vertical: true)
                    .onChange(of: editingName) { _, newValue in
                        store.updateDemoName(demo.id, name: newValue)
                    }
                    .onSubmit {
                        isEditingTitle = false
                    }
            } else {
                Text(demo.name)
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture(count: 2) {
                        editingName = demo.name
                        isEditingTitle = true
                        nameFieldFocused = true
                    }
            }

            Spacer()

            mobileWebPicker
        }

        inlineURLBar
    }

    // MARK: - Unselected State

    @ViewBuilder
    private var unselectedView: some View {
        Text(demo.name)
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(isHovering ? .primary : .secondary)
            .lineLimit(1)
            .frame(height: 32)
            .onHover { hovering in
                isHovering = hovering
            }
    }

    // MARK: - Segmented Control

    @ViewBuilder
    private var mobileWebPicker: some View {
        HStack(spacing: 0) {
            segmentButton(label: "Mobile", isActive: demo.isMobileView) {
                if !demo.isMobileView {
                    store.toggleMobileView(for: demo.id)
                }
            }
            segmentButton(label: "Web", isActive: !demo.isMobileView) {
                if demo.isMobileView {
                    store.toggleMobileView(for: demo.id)
                }
            }
        }
        .padding(2)
        .background(.quaternary, in: Capsule())
        .fixedSize()
    }

    @ViewBuilder
    private func segmentButton(label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: isActive ? .semibold : .medium))
                .foregroundStyle(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(isActive ? AnyShapeStyle(.background) : AnyShapeStyle(.clear), in: Capsule())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Inline URL Bar

    @ViewBuilder
    private var inlineURLBar: some View {
        TextField("https://enterURL.com", text: $editingURL, axis: .vertical)
            .textFieldStyle(.plain)
            .font(.system(size: 13, weight: .medium, design: .monospaced))
            .foregroundStyle(.primary.opacity(0.8))
            .lineLimit(1...5)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(.background, in: RoundedRectangle(cornerRadius: 5))
            .focused($urlFieldFocused)
            .onSubmit {
                store.navigateTo(editingURL)
                store.updateDemoURL(demo.id, url: editingURL)
                urlFieldFocused = false
            }
            .onChange(of: editingURL) { _, newValue in
                store.updateDemoURL(demo.id, url: newValue)
            }
            .onChange(of: store.currentDisplayURL) { _, newValue in
                if isSelected && !urlFieldFocused {
                    editingURL = newValue
                }
            }
    }
}
