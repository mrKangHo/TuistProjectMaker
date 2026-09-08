import Foundation

protocol EnvironmentRepositoryProtocol: Sendable {
    func checkTuistInstalled() -> (isInstalled: Bool, version: String)
    func installTuist(progress: @escaping (String) -> Void, completion: @escaping (Bool) -> Void)
}
