import SwiftUI

struct ProjectNameView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("project_name.title"))
                .font(.title2).bold()
            Text(L("project_name.subtitle"))
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 8) {
                TextField(L("project_name.placeholder"), text: $state.projectName)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(.body, design: .monospaced))

                if let destination = state.destinationURL {
                    Text(destination.path)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                } else if !state.trimmedProjectName.isEmpty {
                    Text(L("project_name.invalid"))
                        .font(.caption)
                        .foregroundStyle(.red)
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
