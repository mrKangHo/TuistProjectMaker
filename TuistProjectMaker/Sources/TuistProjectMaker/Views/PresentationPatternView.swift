import SwiftUI

struct PresentationPatternView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("presentation_pattern.title"))
                .font(.title2).bold()
            Text(L("presentation_pattern.subtitle"))
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                let available = PresentationPattern.available(for: state.uiFramework)
                ForEach(available) { pattern in
                    Button {
                        state.presentationPattern = pattern
                    } label: {
                        HStack {
                            Image(systemName: state.presentationPattern == pattern ? "largecircle.fill.circle" : "circle")
                            VStack(alignment: .leading, spacing: 2) {
                                Text(pattern.rawValue).bold()
                                Text(pattern.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding(12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    if pattern != available.last {
                        Divider()
                    }
                }
            }
            .background(.quaternary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Spacer()
        }
        .padding(32)
        .disabled(!state.includePresentation)
        .opacity(state.includePresentation ? 1 : 0.4)
    }
}
