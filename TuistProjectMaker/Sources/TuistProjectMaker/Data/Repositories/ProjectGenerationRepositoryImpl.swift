import Foundation

@MainActor
final class ProjectGenerationRepositoryImpl: ProjectGenerationRepositoryProtocol {
    func generate(state: WizardState, log: (String) -> Void) throws -> URL {
        try ProjectGenerator.generate(state, log: log)
    }
}
