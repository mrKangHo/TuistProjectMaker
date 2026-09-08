import Foundation

final class EnvironmentRepositoryImpl: EnvironmentRepositoryProtocol {
    func checkTuistInstalled() -> (isInstalled: Bool, version: String) {
        let isInstalled = ShellRunner.which("tuist")
        let version = isInstalled ? ShellRunner.run("/usr/bin/which", ["tuist"]).output.trimmingCharacters(in: .whitespacesAndNewlines) : ""
        return (isInstalled, version)
    }

    func installTuist(progress: @escaping (String) -> Void, completion: @escaping (Bool) -> Void) {
        let script = "curl -fsSL https://get.tuist.io | bash"
        ShellRunner.runStreaming(
            "/bin/bash",
            ["-c", script],
            onOutput: progress,
            onFinish: { code in
                completion(code == 0)
            }
        )
    }
}
