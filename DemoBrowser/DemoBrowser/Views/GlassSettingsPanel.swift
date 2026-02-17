import SwiftUI

struct GlassSettingsPanel: View {
    @Environment(GlassSettings.self) private var settings

    var body: some View {
        @Bindable var settings = settings

        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Liquid Glass Settings")
                    .font(.title2)
                    .bold()
                    .padding(.bottom, 4)

                Divider()

                // Address Bar
                DisclosureGroup("Address Bar") {
                    VStack(alignment: .leading, spacing: 12) {
                        GlassTypePicker(selection: $settings.addressBarGlassType)
                        TintPicker(title: "Tint", selection: $settings.addressBarTint)

                        if settings.addressBarTint != .none {
                            LabeledSlider(title: "Tint Intensity", value: $settings.addressBarTintIntensity)
                        }

                        LabeledSlider(title: "Corner Radius", value: $settings.addressBarCornerRadius, range: 0...24, format: "%.0f px")
                        Toggle("Force Dark", isOn: $settings.addressBarForceDark)
                            .font(.caption)
                    }
                    .padding(.top, 8)
                }

                Divider()

                // Queue Panel
                DisclosureGroup("Queue - Glass") {
                    VStack(alignment: .leading, spacing: 12) {
                        GlassTypePicker(selection: $settings.queueGlassType)
                        TintPicker(title: "Tint", selection: $settings.queueTint)

                        if settings.queueTint != .none {
                            LabeledSlider(title: "Tint Intensity", value: $settings.queueTintIntensity)
                        }

                        LabeledSlider(title: "Corner Radius", value: $settings.queueCornerRadius, range: 0...24, format: "%.0f px")
                        Toggle("Force Dark", isOn: $settings.queueForceDark)
                            .font(.caption)
                    }
                    .padding(.top, 8)
                }

                DisclosureGroup("Queue - Header") {
                    VStack(alignment: .leading, spacing: 12) {
                        ColorOpacityRow(title: "Title Color", color: $settings.queueHeaderColor, opacity: $settings.queueHeaderOpacity)
                        ColorOpacityRow(title: "Button Color", color: $settings.queueHeaderButtonColor, opacity: $settings.queueHeaderButtonOpacity)
                        ColorOpacityRow(title: "Divider Color", color: $settings.queueDividerColor, opacity: $settings.queueDividerOpacity)
                    }
                    .padding(.top, 8)
                }

                DisclosureGroup("Queue - Normal Row") {
                    VStack(alignment: .leading, spacing: 12) {
                        ColorOpacityRow(title: "Background", color: $settings.queueRowNormalBgColor, opacity: $settings.queueRowNormalBgOpacity)
                        ColorOpacityRow(title: "Name Color", color: $settings.queueRowNormalNameColor, opacity: $settings.queueRowNormalNameOpacity)
                        ColorOpacityRow(title: "URL Color", color: $settings.queueRowNormalURLColor, opacity: $settings.queueRowNormalURLOpacity)
                    }
                    .padding(.top, 8)
                }

                DisclosureGroup("Queue - Selected Row") {
                    VStack(alignment: .leading, spacing: 12) {
                        ColorOpacityRow(title: "Background", color: $settings.queueRowSelectedBgColor, opacity: $settings.queueRowSelectedBgOpacity)
                        ColorOpacityRow(title: "Name Color", color: $settings.queueRowSelectedNameColor, opacity: $settings.queueRowSelectedNameOpacity)
                        ColorOpacityRow(title: "URL Color", color: $settings.queueRowSelectedURLColor, opacity: $settings.queueRowSelectedURLOpacity)
                    }
                    .padding(.top, 8)
                }

                Divider()

                // Notes Panel
                DisclosureGroup("Notes Panel") {
                    VStack(alignment: .leading, spacing: 12) {
                        GlassTypePicker(selection: $settings.notesGlassType)
                        TintPicker(title: "Tint", selection: $settings.notesTint)

                        if settings.notesTint != .none {
                            LabeledSlider(title: "Tint Intensity", value: $settings.notesTintIntensity)
                        }

                        LabeledSlider(title: "Corner Radius", value: $settings.notesCornerRadius, range: 0...24, format: "%.0f px")
                        Toggle("Force Dark", isOn: $settings.notesForceDark)
                            .font(.caption)
                        LabeledSlider(title: "Text Opacity", value: $settings.notesTextOpacity)
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
        }
        .frame(width: 350)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Reusable Components

struct GlassTypePicker: View {
    @Binding var selection: GlassType

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Glass Type")
                .font(.caption)
                .foregroundStyle(.secondary)
            Picker("", selection: $selection) {
                ForEach(GlassType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct TintPicker: View {
    var title: String = "Tint Color"
    @Binding var selection: TintPreset

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Picker("", selection: $selection) {
                ForEach(TintPreset.allCases) { tint in
                    HStack(spacing: 6) {
                        if let color = tint.color {
                            Circle().fill(color).frame(width: 8, height: 8)
                        }
                        Text(tint.rawValue)
                    }
                    .tag(tint)
                }
            }
            .labelsHidden()
        }
    }
}

struct ColorOpacityRow: View {
    let title: String
    @Binding var color: TintPreset
    @Binding var opacity: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: 80, alignment: .leading)

                Picker("", selection: $color) {
                    ForEach(TintPreset.allCases) { tint in
                        Text(tint.rawValue).tag(tint)
                    }
                }
                .labelsHidden()
                .frame(maxWidth: .infinity)

                Text(String(format: "%.2f", opacity))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                    .frame(width: 36, alignment: .trailing)
            }

            Slider(value: $opacity, in: 0...1, step: 0.01)
                .controlSize(.small)
        }
    }
}

struct LabeledSlider: View {
    let title: String
    @Binding var value: Double
    var range: ClosedRange<Double> = 0...1
    var format: String = "%.2f"

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(String(format: format, value))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            Slider(value: $value, in: range, step: range.upperBound > 1 ? 1 : 0.01)
                .controlSize(.small)
        }
    }
}
