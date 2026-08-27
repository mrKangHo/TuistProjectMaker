import SwiftUI
import AppKit

struct ProjectSelectView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("project_select.title"))
                .font(.title2).bold()
            Text(L("project_select.subtitle"))
                .foregroundStyle(.secondary)

            HStack {
                Text(state.projectPath?.path ?? L("project_select.no_folder"))
                    .foregroundStyle(state.projectPath == nil ? .secondary : .primary)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Spacer()
                Button(L("project_select.choose_folder")) {
                    let panel = NSOpenPanel()
                    panel.canChooseDirectories = true
                    panel.canChooseFiles = false
                    panel.allowsMultipleSelection = false
                    if panel.runModal() == .OK {
                        state.projectPath = panel.url
                    }
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
