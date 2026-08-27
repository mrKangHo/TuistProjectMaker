import SwiftUI

struct ProjectSettingsView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("project_settings.title"))
                .font(.title2).bold()
            Text(L("project_settings.subtitle"))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L("project_settings.organization")).font(.caption).foregroundStyle(.secondary)
                    TextField(L("project_settings.organization.placeholder"), text: $state.organizationName)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(L("project_settings.bundle_id_prefix")).font(.caption).foregroundStyle(.secondary)
                    TextField(L("project_settings.bundle_id_prefix.placeholder"), text: $state.bundleIdPrefix)
                        .textFieldStyle(.roundedBorder)
                    Text(L("project_settings.resolved_bundle_id") + ": \(state.resolvedBundleId)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(L("project_settings.deployment_target")).font(.caption).foregroundStyle(.secondary)
                    Picker("", selection: $state.deploymentTargetVersion) {
                        ForEach(WizardState.availableIOSVersions, id: \.self) { version in
                            Text("iOS \(version)").tag(version)
                        }
                    }
                    .labelsHidden()
                    .frame(width: 160)
                }
            }
            .padding(12)
            .background(.quaternary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Spacer()
        }
        .padding(32)
    }
}
