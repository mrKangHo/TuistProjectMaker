import Foundation

@MainActor
protocol GenerateProjectUseCaseProtocol {
    func execute(state: WizardState, log: (String) -> Void) throws -> URL
}

@MainActor
final class GenerateProjectUseCase: GenerateProjectUseCaseProtocol {
    private let repository: ProjectGenerationRepositoryProtocol

    init(repository: ProjectGenerationRepositoryProtocol) {
        self.repository = repository
    }

    func execute(state: WizardState, log: (String) -> Void) throws -> URL {
        try repository.generate(state: state, log: log)
    }
}
