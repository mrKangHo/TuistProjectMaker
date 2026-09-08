import Foundation

enum ShellRunner {
    struct Result {
        let exitCode: Int32
        let output: String
    }

    static func run(_ launchPath: String, _ arguments: [String]) -> Result {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: launchPath)
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        do {
            try process.run()
        } catch {
            return Result(exitCode: -1, output: error.localizedDescription)
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        process.waitUntilExit()
        let output = String(data: data, encoding: .utf8) ?? ""
        return Result(exitCode: process.terminationStatus, output: output)
    }

    static func which(_ tool: String) -> Bool {
        run("/usr/bin/which", [tool]).exitCode == 0
    }

    /// Streams stdout line-by-line via onOutput, calls onFinish when the process exits.
    static func runStreaming(_ launchPath: String, _ arguments: [String], onOutput: @escaping (String) -> Void, onFinish: @escaping (Int32) -> Void) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: launchPath)
        process.arguments = arguments

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = pipe

        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            guard !data.isEmpty, let text = String(data: data, encoding: .utf8) else { return }
            DispatchQueue.main.async { onOutput(text) }
        }

        process.terminationHandler = { proc in
            pipe.fileHandleForReading.readabilityHandler = nil
            DispatchQueue.main.async { onFinish(proc.terminationStatus) }
        }

        do {
            try process.run()
        } catch {
            onOutput(error.localizedDescription)
            onFinish(-1)
        }
    }
}
