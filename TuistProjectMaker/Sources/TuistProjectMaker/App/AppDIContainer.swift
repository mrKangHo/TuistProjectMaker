import Foundation

@MainActor
final class AppDIContainer: ObservableObject {
    static let shared = AppDIContainer()

    let environmentRepository: EnvironmentRepositoryProtocol
    let projectGenerationRepository: ProjectGenerationRepositoryProtocol

    let checkEnvironmentUseCase: CheckEnvironmentUseCaseProtocol
    let generateProjectUseCase: GenerateProjectUseCaseProtocol

    private init() {
        let envRepo = EnvironmentRepositoryImpl()
        let genRepo = ProjectGenerationRepositoryImpl()

        self.environmentRepository = envRepo
        self.projectGenerationRepository = genRepo

        self.checkEnvironmentUseCase = CheckEnvironmentUseCase(repository: envRepo)
        self.generateProjectUseCase = GenerateProjectUseCase(repository: genRepo)
    }

    func makeWizardState() -> WizardState {
        WizardState(
            checkEnvironmentUseCase: checkEnvironmentUseCase,
            generateProjectUseCase: generateProjectUseCase
        )
    }
}
