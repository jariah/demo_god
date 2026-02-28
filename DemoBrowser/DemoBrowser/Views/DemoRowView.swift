import SwiftUI

struct DemoRowView: View {
    @Environment(DemoStore.self) private var store
    @Environment(GlassSettings.self) private var gs
    let demo: Demo

    @State private var editingName: String = ""
    @State private var editingURL: String = ""
    @State private var isEditingTitle: Bool = false
    @State private var isEditingURL: Bool = false
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
        HStack(spacing: 0) {
            // Active indicator bar — left edge accent
            Rectangle()
                .fill(isSelected ? Color.white.opacity(0.9) : Color.clear)
                .frame(width: 2)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 0) {
                collapsedRow

                if isSelected {
                    expandedContent
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, isSelected ? 8 : 0)
        }
        .background(
            isSelected
                ? Color.white.opacity(0.06)
                : (isHovering ? Color.white.opacity(0.03) : Color.clear)
        )
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.15), value: isHovering)
        .onHover { hovering in
            isHovering = hovering
        }
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
                isEditingURL = false
            }
        }
    }

    // MARK: - Collapsed Row

    @ViewBuilder
    private var collapsedRow: some View {
        HStack(spacing: 6) {
            if isSelected && isEditingTitle {
                TextField("Name", text: $editingName, axis: .vertical)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: .white.opacity(0.15), radius: 6)
                    .focused($nameFieldFocused)
                    .lineLimit(1...2)
                    .fixedSize(horizontal: false, vertical: true)
                    .onChange(of: editingName) { _, newValue in
                        store.updateDemoName(demo.id, name: newValue)
                    }
                    .onSubmit {
                        isEditingTitle = false
                    }
            } else {
                Text(demo.name)
                    .font(.system(size: isSelected ? 16 : 14, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(.white.opacity(isSelected ? 1.0 : 0.4))
                    .shadow(color: isSelected ? .white.opacity(0.15) : .clear, radius: 6)
                    .lineLimit(1)
                    .onTapGesture(count: 2) {
                        if isSelected {
                            editingName = demo.name
                            isEditingTitle = true
                            nameFieldFocused = true
                        }
                    }
            }

            Spacer()

            // Filled device icons in collapsed state
            if !isSelected {
                collapsedViewModeIcons
            }
        }
        .frame(minHeight: 30)
    }

    // MARK: - Expanded Content

    @ViewBuilder
    private var expandedContent: some View {
        VStack(alignment: .leading, spacing: 6) {
            urlMetadata

            HStack(spacing: 10) {
                expandedViewModeIcons
                Spacer()
            }
            .padding(.top, 2)
        }
        .padding(.top, 4)
    }

    // MARK: - Collapsed Viewport Icons (filled SF Symbols, scaled up)

    @ViewBuilder
    private var collapsedViewModeIcons: some View {
        HStack(spacing: 5) {
            Image(systemName: "iphone")
                .font(.system(size: 12, weight: .medium))
                .symbolVariant(.fill)
                .foregroundStyle(.white.opacity(demo.isMobileView ? 0.3 : 0.1))

            Image(systemName: "desktopcomputer")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.white.opacity(!demo.isMobileView ? 0.3 : 0.1))
        }
    }

    // MARK: - Expanded Viewport Icons (with glow)

    @ViewBuilder
    private var expandedViewModeIcons: some View {
        HStack(spacing: 8) {
            Image(systemName: "iphone")
                .font(.system(size: demo.isMobileView ? 16 : 14, weight: .medium))
                .symbolVariant(.fill)
                .foregroundStyle(.white.opacity(demo.isMobileView ? 1.0 : 0.2))
                .shadow(color: demo.isMobileView ? .white.opacity(0.3) : .clear, radius: 4)
                .onTapGesture {
                    if !demo.isMobileView {
                        store.toggleMobileView(for: demo.id)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: demo.isMobileView)

            Image(systemName: "desktopcomputer")
                .font(.system(size: !demo.isMobileView ? 16 : 14, weight: .medium))
                .foregroundStyle(.white.opacity(!demo.isMobileView ? 1.0 : 0.2))
                .shadow(color: !demo.isMobileView ? .white.opacity(0.3) : .clear, radius: 4)
                .onTapGesture {
                    if demo.isMobileView {
                        store.toggleMobileView(for: demo.id)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: demo.isMobileView)
        }
    }

    // MARK: - URL Metadata

    @ViewBuilder
    private var urlMetadata: some View {
        if isEditingURL {
            TextField("https://enterURL.com", text: $editingURL, axis: .vertical)
                .textFieldStyle(.plain)
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .foregroundStyle(.white.opacity(0.5))
                .lineLimit(1...3)
                .fixedSize(horizontal: false, vertical: true)
                .focused($urlFieldFocused)
                .onSubmit {
                    store.navigateTo(editingURL)
                    store.updateDemoURL(demo.id, url: editingURL)
                    isEditingURL = false
                    urlFieldFocused = false
                }
                .onChange(of: editingURL) { _, newValue in
                    store.updateDemoURL(demo.id, url: newValue)
                }
        } else {
            Text(displayURL)
                .font(.system(size: 11, weight: .regular, design: .monospaced))
                .foregroundStyle(.white.opacity(0.3))
                .lineLimit(1)
                .truncationMode(.middle)
                .onTapGesture {
                    editingURL = demo.url
                    isEditingURL = true
                    urlFieldFocused = true
                }
                .onChange(of: store.currentDisplayURL) { _, newValue in
                    if isSelected && !urlFieldFocused {
                        editingURL = newValue
                    }
                }
        }
    }

    private var displayURL: String {
        let url = demo.url.isEmpty ? "No URL" : demo.url
        return url
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
    }
}
