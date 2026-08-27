import SwiftUI

struct SummaryView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("summary.title"))
                .font(.title2).bold()
            Text(L("summary.subtitle"))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                row(L("summary.project_name"), state.trimmedProjectName.isEmpty ? "-" : state.trimmedProjectName)
                row(L("summary.destination"), state.destinationURL?.path ?? "-")
                row(L("summary.organization"), state.organizationName)
                row("Bundle ID", state.resolvedBundleId)
                row(L("summary.deployment_target"), "iOS \(state.deploymentTargetVersion)")
                row("tuist", state.isTuistInstalled == true ? L("environment_check.installed") : L("environment_check.not_installed"))
                if state.includeDomain {
                    row(L("summary.domain_elements"), "Entity \(state.domainEntities.count) / UseCase \(state.domainUseCases.count) / Repository \(state.domainRepositoryInterfaces.count)")
                }
                if state.includeData {
                    row(L("summary.data_elements"), "\(L("data_config.repository_impl.title")) \(state.dataRepositoryImpls.count) / DTO \(state.dataDTOs.count) / DataSource \(state.dataDataSources.count)")
                }
                row(L("summary.ui_framework"), state.includePresentation ? state.uiFramework.rawValue : "-")
                row(L("summary.presentation_pattern"), state.includePresentation ? state.presentationPattern.rawValue : "-")
                if state.includePresentation {
                    row(L("summary.screens"), state.presentationScreens.map(\.name).joined(separator: ", "))
                }
            }
            .padding(12)
            .background(.quaternary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            if state.generatedProjectURL != nil {
                Text(L("summary.generated"))
                    .foregroundStyle(.green)
                    .font(.callout)
            }

            if let error = state.generationError {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.callout)
            }

            if !state.generationLog.isEmpty {
                ScrollView {
                    Text(state.generationLog)
                        .font(.system(.caption, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }
                .frame(maxHeight: 160)
                .padding(8)
                .background(.black.opacity(0.85))
                .foregroundStyle(.green)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Spacer()
        }
        .padding(32)
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).foregroundStyle(.secondary).frame(width: 140, alignment: .leading)
            Text(value)
            Spacer()
        }
    }
}
