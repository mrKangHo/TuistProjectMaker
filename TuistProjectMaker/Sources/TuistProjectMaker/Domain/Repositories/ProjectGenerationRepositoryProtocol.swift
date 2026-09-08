import Foundation

@MainActor
protocol ProjectGenerationRepositoryProtocol {
    func generate(state: WizardState, log: (String) -> Void) throws -> URL
}
