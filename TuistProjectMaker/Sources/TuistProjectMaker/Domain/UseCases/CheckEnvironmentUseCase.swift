import Foundation

protocol CheckEnvironmentUseCaseProtocol: Sendable {
    func isTuistInstalled() -> Bool
    func installTuist(progress: @escaping (String) -> Void, completion: @escaping (Bool) -> Void)
}

final class CheckEnvironmentUseCase: CheckEnvironmentUseCaseProtocol {
    private let repository: EnvironmentRepositoryProtocol

    init(repository: EnvironmentRepositoryProtocol) {
        self.repository = repository
    }

    func isTuistInstalled() -> Bool {
        repository.checkTuistInstalled().isInstalled
    }

    func installTuist(progress: @escaping (String) -> Void, completion: @escaping (Bool) -> Void) {
        repository.installTuist(progress: progress, completion: completion)
    }
}
