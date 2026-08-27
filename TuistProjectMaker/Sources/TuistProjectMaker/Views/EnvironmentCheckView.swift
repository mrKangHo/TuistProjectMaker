import SwiftUI

struct EnvironmentCheckView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L("environment_check.title"))
                .font(.title2).bold()
            Text(L("environment_check.subtitle"))
                .foregroundStyle(.secondary)

            HStack(spacing: 12) {
                statusIcon
                Text(statusText)
                Spacer()
                if state.isTuistInstalled == false {
                    Button(state.isInstalling ? L("environment_check.installing") : "brew install tuist") {
                        installTuist()
                    }
                    .disabled(state.isInstalling)
                }
                Button(L("environment_check.recheck")) { checkTuist() }
                    .disabled(state.isInstalling)
            }
            .padding(12)
            .background(.quaternary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            if !state.installLog.isEmpty {
                ScrollView {
                    Text(state.installLog)
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
        .onAppear { if state.isTuistInstalled == nil { checkTuist() } }
    }

    private var statusIcon: some View {
        Group {
            switch state.isTuistInstalled {
            case .some(true):
                Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
            case .some(false):
                Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
            case .none:
                ProgressView().controlSize(.small)
            }
        }
    }

    private var statusText: String {
        switch state.isTuistInstalled {
        case .some(true): return L("environment_check.installed")
        case .some(false): return L("environment_check.not_installed")
        case .none: return L("environment_check.checking")
        }
    }

    private func checkTuist() {
        state.isTuistInstalled = ShellRunner.which("tuist")
    }

    private func installTuist() {
        guard let brewPath = ["/opt/homebrew/bin/brew", "/usr/local/bin/brew"].first(where: { FileManager.default.fileExists(atPath: $0) }) else {
            state.installLog += L("environment_check.brew_not_found") + "\n"
            return
        }
        state.isInstalling = true
        state.installLog = ""
        ShellRunner.runStreaming(brewPath, ["install", "tuist"], onOutput: { chunk in
            state.installLog += chunk
        }, onFinish: { code in
            state.isInstalling = false
            state.isTuistInstalled = (code == 0) && ShellRunner.which("tuist")
        })
    }
}
