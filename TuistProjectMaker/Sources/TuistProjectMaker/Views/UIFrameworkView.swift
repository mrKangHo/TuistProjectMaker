import SwiftUI

struct UIFrameworkView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("ui_framework.title"))
                .font(.title2).bold()
            Text(L("ui_framework.subtitle"))
                .foregroundStyle(.secondary)

            VStack(spacing: 0) {
                ForEach(UIFramework.allCases) { framework in
                    Button {
                        state.uiFramework = framework
                    } label: {
                        HStack {
                            Image(systemName: state.uiFramework == framework ? "largecircle.fill.circle" : "circle")
                            VStack(alignment: .leading, spacing: 2) {
                                Text(framework.rawValue).bold()
                                Text(framework.description)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding(12)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    if framework != UIFramework.allCases.last {
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
