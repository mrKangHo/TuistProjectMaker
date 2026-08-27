import SwiftUI

struct DomainConfigView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(L("domain_config.title"))
                    .font(.title2).bold()
                Text(L("domain_config.subtitle"))
                    .foregroundStyle(.secondary)

                Toggle(L("domain_config.toggle"), isOn: $state.includeDomain)
                    .padding(12)
                    .background(.quaternary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                ElementListEditor(
                    title: "Entity",
                    placeholder: L("domain_config.entity.placeholder"),
                    elements: $state.domainEntities,
                    disabled: !state.includeDomain
                )
                ElementListEditor(
                    title: "UseCase",
                    placeholder: L("domain_config.usecase.placeholder"),
                    elements: $state.domainUseCases,
                    disabled: !state.includeDomain
                )
                ElementListEditor(
                    title: L("domain_config.repository.title"),
                    placeholder: L("domain_config.repository.placeholder"),
                    elements: $state.domainRepositoryInterfaces,
                    disabled: !state.includeDomain
                )
            }
            .padding(32)
        }
    }
}
