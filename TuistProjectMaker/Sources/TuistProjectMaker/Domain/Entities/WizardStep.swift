import Foundation

public enum WizardStep: Int, CaseIterable, Identifiable, Sendable {
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

    public var id: Int { rawValue }

    public var title: String {
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
