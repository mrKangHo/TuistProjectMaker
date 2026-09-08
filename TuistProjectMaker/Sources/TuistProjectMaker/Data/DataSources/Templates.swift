import Foundation

@MainActor
enum Templates {
    static func config() -> String {
        """
        import ProjectDescription

        let config = Config()
        """
    }

    static func env(name: String, bundleIdPrefix: String, organizationName: String, deploymentTargetVersion: String) -> String {
        """
        import ProjectDescription

        public enum ENV {
            static let organizationName: String = "\(organizationName)"
            static let prefixBundleId: String = "\(bundleIdPrefix)"
            static let deploymentTarget: DeploymentTargets? = .iOS("\(deploymentTargetVersion)")
        }
        """
    }

    static func project(name: String, bundleId: String, organizationName: String, deploymentTargetVersion: String) -> String {
        """
        import ProjectDescription

        let project = Project(
            name: "\(name)",
            organizationName: "\(organizationName)",
            targets: [
                .target(
                    name: "\(name)",
                    destinations: .iOS,
                    product: .app,
                    bundleId: "\(bundleId)",
                    deploymentTargets: .iOS("\(deploymentTargetVersion)"),
                    infoPlist: .default,
                    sources: ["Sources/**"],
                    resources: ["Resources/**"]
                )
            ]
        )
        """
    }

    static func workspace(name: String) -> String {
        """
        import ProjectDescription

        let workspace = Workspace(
            name: "\(name)",
            projects: ["."]
        )
        """
    }

    static func readme(state: WizardState, name: String) -> String {
        var layers: [String] = []
        if state.includeDomain {
            layers.append("Domain (Entity \(state.domainEntities.count), UseCase \(state.domainUseCases.count), Repository Interface \(state.domainRepositoryInterfaces.count))")
        }
        if state.includeData {
            layers.append("Data (Repository 구현체 \(state.dataRepositoryImpls.count), DTO \(state.dataDTOs.count), DataSource \(state.dataDataSources.count))")
        }
        if state.includePresentation {
            layers.append("Presentation (\(state.uiFramework.rawValue) / \(state.presentationPattern.rawValue), 화면 \(state.presentationScreens.count)개)")
        }
        return """
        # \(name)

        TuistProjectMaker 로 생성된 프로젝트입니다.

        ## 구성
        - \(layers.joined(separator: "\n- "))

        ## 다음 단계
        1. `tuist generate` 실행해서 Xcode 프로젝트 생성
        2. UIKit 선택한 경우 Info.plist에 Scene 설정 직접 추가 필요할 수 있음
        """
    }

    // MARK: Domain

    static func entity(name: String) -> String {
        """
        struct \(name) {

        }
        """
    }

    static func useCase(name: String, repositoryName: String?) -> String {
        guard let repositoryName else {
            return """
            protocol \(name)UseCaseProtocol {
                func execute()
            }

            final class \(name)UseCase: \(name)UseCaseProtocol {
                func execute() {

                }
            }
            """
        }
        return """
        protocol \(name)UseCaseProtocol {
            func execute()
        }

        final class \(name)UseCase: \(name)UseCaseProtocol {
            private let repository: \(repositoryName)Repository

            init(repository: \(repositoryName)Repository) {
                self.repository = repository
            }

            func execute() {

            }
        }
        """
    }

    static func repositoryInterface(name: String) -> String {
        """
        protocol \(name)Repository {

        }
        """
    }

    // MARK: Data

    static func repositoryImpl(name: String, dataSourceName: String?) -> String {
        guard let dataSourceName else {
            return """
            final class \(name)RepositoryImpl: \(name)Repository {

            }
            """
        }
        return """
        final class \(name)RepositoryImpl: \(name)Repository {
            private let dataSource: \(dataSourceName)DataSource

            init(dataSource: \(dataSourceName)DataSource) {
                self.dataSource = dataSource
            }
        }
        """
    }

    static func dto(name: String) -> String {
        """
        struct \(name)DTO: Decodable {

        }

        extension \(name)DTO {
            func toDomain() -> \(name) {
                \(name)()
            }
        }
        """
    }

    static func dataSource(name: String) -> String {
        """
        protocol \(name)DataSource {

        }

        final class \(name)DataSourceImpl: \(name)DataSource {

        }
        """
    }

    // MARK: SwiftUI

    static func swiftUIApp(appName: String, entryScreen: String) -> String {
        """
        import SwiftUI

        @main
        struct \(appName)App: App {
            var body: some Scene {
                WindowGroup {
                    DIContainer.shared.make\(entryScreen)View()
                }
            }
        }
        """
    }

    static func swiftUITCAApp(appName: String, entryScreen: String) -> String {
        """
        import SwiftUI
        import ComposableArchitecture

        @main
        struct \(appName)App: App {
            var body: some Scene {
                WindowGroup {
                    \(entryScreen)View(store: Store(initialState: \(entryScreen)Feature.State()) {
                        \(entryScreen)Feature()
                    })
                }
            }
        }
        """
    }

    static func swiftUIView(name: String) -> String {
        """
        import SwiftUI

        struct \(name)View: View {
            @StateObject private var viewModel: \(name)ViewModel

            init(viewModel: \(name)ViewModel) {
                _viewModel = StateObject(wrappedValue: viewModel)
            }

            var body: some View {
                Text("\(name)")
            }
        }
        """
    }

    static func viewModel(name: String, useCaseName: String?) -> String {
        guard let useCaseName else {
            return """
            import Foundation

            final class \(name)ViewModel: ObservableObject {

            }
            """
        }
        return """
        import Foundation

        final class \(name)ViewModel: ObservableObject {
            private let useCase: \(useCaseName)UseCaseProtocol

            init(useCase: \(useCaseName)UseCaseProtocol) {
                self.useCase = useCase
            }
        }
        """
    }

    static func coordinator(name: String) -> String {
        """
        import Foundation

        protocol \(name)CoordinatorProtocol: AnyObject {
            func start()
        }

        final class \(name)Coordinator: \(name)CoordinatorProtocol {
            func start() {

            }
        }
        """
    }

    // MARK: TCA

    static func tcaFeature(name: String) -> String {
        """
        import ComposableArchitecture

        @Reducer
        struct \(name)Feature {
            @ObservableState
            struct State: Equatable {

            }

            enum Action {

            }

            var body: some ReducerOf<Self> {
                Reduce { state, action in
                    return .none
                }
            }
        }
        """
    }

    static func tcaView(name: String) -> String {
        """
        import SwiftUI
        import ComposableArchitecture

        struct \(name)View: View {
            let store: StoreOf<\(name)Feature>

            var body: some View {
                Text("\(name)")
            }
        }
        """
    }

    // MARK: UIKit

    static func uikitAppDelegate(entryScreen: String) -> String {
        """
        import UIKit

        @main
        final class AppDelegate: UIResponder, UIApplicationDelegate {
            var window: UIWindow?

            func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                let window = UIWindow(frame: UIScreen.main.bounds)
                window.rootViewController = DIContainer.shared.make\(entryScreen)ViewController()
                window.makeKeyAndVisible()
                self.window = window
                return true
            }
        }
        """
    }

    static func uikitViewController(name: String) -> String {
        """
        import UIKit

        final class \(name)ViewController: UIViewController {
            private let viewModel: \(name)ViewModel

            init(viewModel: \(name)ViewModel) {
                self.viewModel = viewModel
                super.init(nibName: nil, bundle: nil)
            }

            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }

            override func viewDidLoad() {
                super.viewDidLoad()
                view.backgroundColor = .systemBackground
            }
        }
        """
    }

    // MARK: DI Container

    static func diContainerHeader() -> String {
        """
        import Foundation

        final class DIContainer {
            static let shared = DIContainer()

            private init() {}
        }
        """
    }
}
