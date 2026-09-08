import Foundation

public enum PresentationPattern: String, CaseIterable, Identifiable, Sendable {
    case mvvm = "MVVM"
    case mvvmC = "MVVM-C"
    case tca = "TCA"

    public var id: String { rawValue }

    public var description: String {
        switch self {
        case .mvvm: return L("pattern.mvvm.desc")
        case .mvvmC: return L("pattern.mvvmc.desc")
        case .tca: return L("pattern.tca.desc")
        }
    }

    public static func available(for framework: UIFramework) -> [PresentationPattern] {
        switch framework {
        case .swiftUI: return [.mvvm, .mvvmC, .tca]
        case .uikit: return [.mvvm, .mvvmC]
        }
    }
}
