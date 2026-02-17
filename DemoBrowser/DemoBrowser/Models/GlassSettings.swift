import SwiftUI

enum GlassType: String, CaseIterable, Identifiable {
    case regular = "Regular"
    case clear = "Clear"
    case none = "None"

    var id: String { rawValue }
}

enum TintPreset: String, CaseIterable, Identifiable {
    case none = "None"
    case blue = "Blue"
    case purple = "Purple"
    case red = "Red"
    case green = "Green"
    case orange = "Orange"
    case cyan = "Cyan"
    case gray = "Gray"
    case white = "White"
    case black = "Black"

    var id: String { rawValue }

    var color: Color? {
        switch self {
        case .none: return nil
        case .blue: return .blue
        case .purple: return .purple
        case .red: return .red
        case .green: return .green
        case .orange: return .orange
        case .cyan: return .cyan
        case .gray: return .gray
        case .white: return .white
        case .black: return .black
        }
    }
}

@Observable
final class GlassSettings {
    // Address Bar
    var addressBarGlassType: GlassType = .regular
    var addressBarTint: TintPreset = .none
    var addressBarTintIntensity: Double = 0.5
    var addressBarCornerRadius: Double = 10
    var addressBarForceDark: Bool = true

    // Queue Panel - Glass
    var queueGlassType: GlassType = .regular
    var queueTint: TintPreset = .none
    var queueTintIntensity: Double = 0.5
    var queueCornerRadius: Double = 12
    var queueForceDark: Bool = true

    // Queue Panel - Header
    var queueHeaderColor: TintPreset = .white
    var queueHeaderOpacity: Double = 0.9
    var queueHeaderButtonColor: TintPreset = .white
    var queueHeaderButtonOpacity: Double = 0.6
    var queueDividerColor: TintPreset = .white
    var queueDividerOpacity: Double = 0.1

    // Queue Panel - Row Normal State
    var queueRowNormalBgColor: TintPreset = .white
    var queueRowNormalBgOpacity: Double = 0.04
    var queueRowNormalNameColor: TintPreset = .white
    var queueRowNormalNameOpacity: Double = 0.85
    var queueRowNormalURLColor: TintPreset = .white
    var queueRowNormalURLOpacity: Double = 0.4

    // Queue Panel - Row Selected State
    var queueRowSelectedBgColor: TintPreset = .white
    var queueRowSelectedBgOpacity: Double = 0.15
    var queueRowSelectedNameColor: TintPreset = .white
    var queueRowSelectedNameOpacity: Double = 1.0
    var queueRowSelectedURLColor: TintPreset = .white
    var queueRowSelectedURLOpacity: Double = 0.6

    // Notes Panel
    var notesGlassType: GlassType = .regular
    var notesTint: TintPreset = .none
    var notesTintIntensity: Double = 0.5
    var notesCornerRadius: Double = 12
    var notesForceDark: Bool = true
    var notesTextOpacity: Double = 0.85

    // Compose Glass values
    func makeGlass(type: GlassType, tint: TintPreset, intensity: Double) -> Glass {
        var glass: Glass
        switch type {
        case .regular: glass = .regular
        case .clear: glass = .clear
        case .none: glass = .identity
        }
        if let color = tint.color {
            glass = glass.tint(color.opacity(intensity))
        }
        return glass
    }

    var addressBarGlass: Glass {
        makeGlass(type: addressBarGlassType, tint: addressBarTint, intensity: addressBarTintIntensity)
    }

    var queueGlass: Glass {
        makeGlass(type: queueGlassType, tint: queueTint, intensity: queueTintIntensity)
    }

    var notesGlass: Glass {
        makeGlass(type: notesGlassType, tint: notesTint, intensity: notesTintIntensity)
    }

    // Helper to resolve a TintPreset + opacity into a Color
    func resolveColor(_ preset: TintPreset, opacity: Double, fallback: Color = .white) -> Color {
        (preset.color ?? fallback).opacity(opacity)
    }
}
