import Foundation
import SwiftUI
import AppKit

@MainActor
final class WizardState: ObservableObject {
    @Published var currentStep: WizardStep = .projectSelect
    @Published var isMovingForward: Bool = true

    @Published var projectPath: URL?
    @Published var projectName: String = ""

    @Published var isTuistInstalled: Bool?
    @Published var isInstalling: Bool = false
    @Published var installLog: String = ""

    @Published var isGenerating: Bool = false
    @Published var generationLog: String = ""
    @Published var generatedProjectURL: URL?
    @Published var generationError: String?

    private let checkEnvironmentUseCase: CheckEnvironmentUseCaseProtocol
    private let generateProjectUseCase: GenerateProjectUseCaseProtocol

    init(
        checkEnvironmentUseCase: CheckEnvironmentUseCaseProtocol? = nil,
        generateProjectUseCase: GenerateProjectUseCaseProtocol? = nil
    ) {
        self.checkEnvironmentUseCase = checkEnvironmentUseCase ?? AppDIContainer.shared.checkEnvironmentUseCase
        self.generateProjectUseCase = generateProjectUseCase ?? AppDIContainer.shared.generateProjectUseCase
    }

    var trimmedProjectName: String {
        projectName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isProjectNameValid: Bool {
        let name = trimmedProjectName
        guard !name.isEmpty, !name.contains("/") else { return false }
        return true
    }

    var destinationURL: URL? {
        guard let projectPath, isProjectNameValid else { return nil }
        return projectPath.appendingPathComponent(trimmedProjectName)
    }

    static let availableIOSVersions = ["16.0", "17.0", "18.0", "26.0"]

    @Published var organizationName: String = ""
    @Published var bundleIdPrefix: String = ""
    @Published var deploymentTargetVersion: String = "17.0"

    var isProjectSettingsValid: Bool {
        !organizationName.trimmingCharacters(in: .whitespaces).isEmpty
            && !bundleIdPrefix.trimmingCharacters(in: .whitespaces).isEmpty
            && !deploymentTargetVersion.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var resolvedBundleId: String {
        "\(bundleIdPrefix).\(trimmedProjectName)"
    }

    @Published var includeDomain: Bool = true
    @Published var includeData: Bool = true
    @Published var includePresentation: Bool = true

    @Published var domainEntities: [NamedElement] = []
    @Published var domainUseCases: [NamedElement] = []
    @Published var domainRepositoryInterfaces: [NamedElement] = []

    @Published var dataRepositoryImpls: [NamedElement] = []
    @Published var dataDTOs: [NamedElement] = []
    @Published var dataDataSources: [NamedElement] = []

    @Published var presentationScreens: [NamedElement] = [NamedElement(name: "Main")]

    @Published var uiFramework: UIFramework = .swiftUI {
        didSet {
            let available = PresentationPattern.available(for: uiFramework)
            if !available.contains(presentationPattern) {
                presentationPattern = available.first ?? .mvvm
            }
        }
    }

    @Published var presentationPattern: PresentationPattern = .mvvm

    var canAdvance: Bool {
        switch currentStep {
        case .projectSelect:
            return projectPath != nil
        case .projectName:
            return isProjectNameValid
        case .projectSettings:
            return isProjectSettingsValid
        case .environmentCheck:
            return isTuistInstalled == true
        case .domainConfig:
            return true
        case .dataConfig:
            return true
        case .presentationConfig:
            return true
        case .uiFramework:
            return true
        case .presentationPattern:
            return true
        case .summary:
            return false
        }
    }

    func goNext() {
        guard let next = WizardStep(rawValue: currentStep.rawValue + 1) else { return }
        isMovingForward = true
        currentStep = next
    }

    func goBack() {
        guard let prev = WizardStep(rawValue: currentStep.rawValue - 1) else { return }
        isMovingForward = false
        currentStep = prev
    }

    func checkEnvironment() {
        isTuistInstalled = checkEnvironmentUseCase.isTuistInstalled()
    }

    func installTuist() {
        isInstalling = true
        installLog = ""
        checkEnvironmentUseCase.installTuist(progress: { [weak self] output in
            self?.installLog += output
        }, completion: { [weak self] success in
            self?.isInstalling = false
            self?.isTuistInstalled = success
        })
    }

    func generateAndReveal() {
        isGenerating = true
        generationError = nil
        generationLog = ""
        do {
            let url = try generateProjectUseCase.execute(state: self) { [weak self] line in
                self?.generationLog += line + "\n"
            }
            generatedProjectURL = url
            NSWorkspace.shared.activateFileViewerSelecting([url])
        } catch {
            generationError = error.localizedDescription
        }
        isGenerating = false
    }
}
