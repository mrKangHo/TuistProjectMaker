import Foundation

public enum UIFramework: String, CaseIterable, Identifiable, Sendable {
    case swiftUI = "SwiftUI"
    case uikit = "UIKit"

    public var id: String { rawValue }

    public var description: String {
        switch self {
        case .swiftUI: return L("framework.swiftui.desc")
        case .uikit: return L("framework.uikit.desc")
        }
    }
}
