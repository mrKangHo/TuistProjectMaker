import SwiftUI

struct DataConfigView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(L("data_config.title"))
                    .font(.title2).bold()
                Text(L("data_config.subtitle"))
                    .foregroundStyle(.secondary)

                Toggle(L("data_config.toggle"), isOn: $state.includeData)
                    .padding(12)
                    .background(.quaternary.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                ElementListEditor(
                    title: L("data_config.repository_impl.title"),
                    placeholder: L("data_config.repository_impl.placeholder"),
                    elements: $state.dataRepositoryImpls,
                    disabled: !state.includeData
                )
                ElementListEditor(
                    title: "DTO",
                    placeholder: L("data_config.dto.placeholder"),
                    elements: $state.dataDTOs,
                    disabled: !state.includeData
                )
                ElementListEditor(
                    title: "DataSource",
                    placeholder: L("data_config.datasource.placeholder"),
                    elements: $state.dataDataSources,
                    disabled: !state.includeData
                )
            }
            .padding(32)
        }
    }
}
