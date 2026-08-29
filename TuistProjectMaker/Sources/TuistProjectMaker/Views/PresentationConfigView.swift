import SwiftUI

struct PresentationConfigView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(L("presentation_config.title"))
                    .font(.title2).bold()
                Text(L("presentation_config.subtitle"))
                    .foregroundStyle(.secondary)

                Toggle(L("presentation_config.toggle"), isOn: $state.includePresentation)
                    .padding(12)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                ElementListEditor(
                    title: L("presentation_config.screen.title"),
                    placeholder: L("presentation_config.screen.placeholder"),
                    elements: $state.presentationScreens,
                    disabled: !state.includePresentation
                )
            }
            .padding(32)
        }
    }
}
