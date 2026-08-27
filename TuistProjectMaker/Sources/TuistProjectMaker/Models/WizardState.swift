import Foundation
import SwiftUI
import AppKit

struct NamedElement: Identifiable, Hashable {
    let id = UUID()
    var name: String
}

enum WizardStep: Int, CaseIterable, Identifiable {
    case projectSelect
    case projectName
    case projectSettings
    case environmentCheck
    case domainConfig
    case dataConfig
    case presentationConfig
    case uiFramework
    case presentationPattern
    case summary

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .projectSelect: return L("step.project_select")
        case .projectName: return L("step.project_name")
        case .projectSettings: return L("step.project_settings")
        case .environmentCheck: return L("step.environment_check")
        case .domainConfig: return L("step.domain_config")
        case .dataConfig: return L("step.data_config")
        case .presentationConfig: return L("step.presentation_config")
        case .uiFramework: return L("step.ui_framework")
        case .presentationPattern: return L("step.presentation_pattern")
        case .summary: return L("step.summary")
        }
    }
}

enum UIFramework: String, CaseIterable, Identifiable {
    case swiftUI = "SwiftUI"
    case uikit = "UIKit"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .swiftUI: return L("framework.swiftui.desc")
        case .uikit: return L("framework.uikit.desc")
        }
    }
}

enum PresentationPattern: String, CaseIterable, Identifiable {
    case mvvm = "MVVM"
    case mvvmC = "MVVM-C"
    case tca = "TCA"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .mvvm: return L("pattern.mvvm.desc")
        case .mvvmC: return L("pattern.mvvmc.desc")
        case .tca: return L("pattern.tca.desc")
        }
    }

    static func available(for framework: UIFramework) -> [PresentationPattern] {
        switch framework {
        case .swiftUI: return [.mvvm, .mvvmC, .tca]
        case .uikit: return [.mvvm, .mvvmC]
        }
    }
}

@MainActor
final class WizardState: ObservableObject {
    @Published var currentStep: WizardStep = .projectSelect

    @Published var projectPath: URL?
    @Published var projectName: String = ""

    @Published var isTuistInstalled: Bool?
    @Published var isInstalling: Bool = false
    @Published var installLog: String = ""

    @Published var isGenerating: Bool = false
    @Published var generationLog: String = ""
    @Published var generatedProjectURL: URL?
    @Published var generationError: String?

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
        currentStep = next
    }

    func goBack() {
        guard let prev = WizardStep(rawValue: currentStep.rawValue - 1) else { return }
        currentStep = prev
    }

    func generateAndReveal() {
        isGenerating = true
        generationError = nil
        generationLog = ""
        do {
            let url = try ProjectGenerator.generate(self) { [weak self] line in
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
