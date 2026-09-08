import SwiftUI

extension Animation {
    /// Critically damped — the default for programmatic UI motion (no overshoot).
    static var appleDefault: Animation {
        .spring(response: 0.35, dampingFraction: 1.0)
    }
}

/// Highlights on press-down (not release) and settles with a critically damped spring,
/// so feedback is instant instead of waiting for the click to complete.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 1.0), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableButtonStyle {
    static var pressable: PressableButtonStyle { PressableButtonStyle() }
}

/// For full-width selectable rows, where scaling the whole row down reads oddly —
/// tints on press-down instead so feedback is still instant.
struct SelectableRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.primary.opacity(0.06) : Color.clear)
            .animation(.spring(response: 0.2, dampingFraction: 1.0), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == SelectableRowButtonStyle {
    static var selectableRow: SelectableRowButtonStyle { SelectableRowButtonStyle() }
}
