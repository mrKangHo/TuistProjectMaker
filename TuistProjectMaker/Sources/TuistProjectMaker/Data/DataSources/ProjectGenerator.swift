import Foundation

enum ProjectGeneratorError: LocalizedError {
    case noDestination
    case alreadyExists(String)

    var errorDescription: String? {
        switch self {
        case .noDestination:
            return L("error.no_destination")
        case .alreadyExists(let path):
            return L("error.already_exists") + ": \(path)"
        }
    }
}

@MainActor
enum ProjectGenerator {
    static func generate(_ state: WizardState, log: (String) -> Void) throws -> URL {
        guard let root = state.destinationURL else { throw ProjectGeneratorError.noDestination }
        let fm = FileManager.default

        if fm.fileExists(atPath: root.path) {
            throw ProjectGeneratorError.alreadyExists(root.path)
        }

        let name = state.trimmedProjectName

        log(L("log.create_folder") + ": \(root.path)")
        try fm.createDirectory(at: root, withIntermediateDirectories: true)

        let tuistHelpersDir = root.appendingPathComponent("Tuist/ProjectDescriptionHelpers")
        try fm.createDirectory(at: tuistHelpersDir, withIntermediateDirectories: true)

        let sourcesDir = root.appendingPathComponent("Sources")
        try fm.createDirectory(at: sourcesDir, withIntermediateDirectories: true)
        try fm.createDirectory(at: root.appendingPathComponent("Resources"), withIntermediateDirectories: true)

        if state.includeDomain {
            log(L("log.domain") + " (Entity \(state.domainEntities.count), UseCase \(state.domainUseCases.count), Repository \(state.domainRepositoryInterfaces.count))")
            try generateDomain(state: state, sourcesDir: sourcesDir)
        }
        if state.includeData {
            log(L("log.data") + " (\(L("data_config.repository_impl.title")) \(state.dataRepositoryImpls.count), DTO \(state.dataDTOs.count), DataSource \(state.dataDataSources.count))")
            try generateData(state: state, sourcesDir: sourcesDir)
        }
        if state.includePresentation {
            log(L("log.presentation") + " (\(state.uiFramework.rawValue) / \(state.presentationPattern.rawValue), \(L("summary.screens")) \(state.presentationScreens.count))")
            try generatePresentation(state: state, sourcesDir: sourcesDir, appName: name, log: log)

            log(L("log.di_container"))
            try generateDIContainer(state: state, sourcesDir: sourcesDir)
        }

        log(L("log.manifest"))
        try write(Templates.config(), to: root.appendingPathComponent("Tuist/Config.swift"))
        try write(Templates.env(name: name, bundleIdPrefix: state.bundleIdPrefix, organizationName: state.organizationName, deploymentTargetVersion: state.deploymentTargetVersion), to: tuistHelpersDir.appendingPathComponent("ENV.swift"))
        try write(Templates.project(name: name, bundleId: state.resolvedBundleId, organizationName: state.organizationName, deploymentTargetVersion: state.deploymentTargetVersion), to: root.appendingPathComponent("Project.swift"))
        try write(Templates.workspace(name: name), to: root.appendingPathComponent("Workspace.swift"))
        try write(Templates.readme(state: state, name: name), to: root.appendingPathComponent("README.md"))

        log(L("log.done") + ": \(root.path)")
        return root
    }

    // MARK: - Cross-layer name matching (drives constructor injection)

    /// A RepositoryImpl injects a DataSource whenever a DataSource with the same name exists.
    private static func dataSourceMatch(for repositoryImplName: String, state: WizardState) -> String? {
        state.dataDataSources.first(where: { $0.name == repositoryImplName })?.name
    }

    /// A UseCase injects a Repository only when BOTH the Domain interface and a concrete
    /// Data impl exist with the same name, so the container can always build a real instance.
    private static func repositoryMatch(for useCaseName: String, state: WizardState) -> String? {
        guard state.domainRepositoryInterfaces.contains(where: { $0.name == useCaseName }),
              state.dataRepositoryImpls.contains(where: { $0.name == useCaseName }) else { return nil }
        return useCaseName
    }

    /// A ViewModel injects a UseCase whenever a Domain UseCase with the same name as the screen exists.
    private static func useCaseMatch(for screenName: String, state: WizardState) -> String? {
        state.domainUseCases.first(where: { $0.name == screenName })?.name
    }

    private static func generateDomain(state: WizardState, sourcesDir: URL) throws {
        let fm = FileManager.default
        let domainDir = sourcesDir.appendingPathComponent("Domain")
        try fm.createDirectory(at: domainDir, withIntermediateDirectories: true)

        if !state.domainEntities.isEmpty {
            let dir = domainDir.appendingPathComponent("Entity")
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            for element in state.domainEntities {
                try write(Templates.entity(name: element.name), to: dir.appendingPathComponent("\(element.name).swift"))
            }
        }
        if !state.domainUseCases.isEmpty {
            let dir = domainDir.appendingPathComponent("UseCase")
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            for element in state.domainUseCases {
                let repositoryName = repositoryMatch(for: element.name, state: state)
                try write(Templates.useCase(name: element.name, repositoryName: repositoryName), to: dir.appendingPathComponent("\(element.name)UseCase.swift"))
            }
        }
        if !state.domainRepositoryInterfaces.isEmpty {
            let dir = domainDir.appendingPathComponent("Repository")
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            for element in state.domainRepositoryInterfaces {
                try write(Templates.repositoryInterface(name: element.name), to: dir.appendingPathComponent("\(element.name)Repository.swift"))
            }
        }
    }

    private static func generateData(state: WizardState, sourcesDir: URL) throws {
        let fm = FileManager.default
        let dataDir = sourcesDir.appendingPathComponent("Data")
        try fm.createDirectory(at: dataDir, withIntermediateDirectories: true)

        if !state.dataRepositoryImpls.isEmpty {
            let dir = dataDir.appendingPathComponent("Repository")
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            for element in state.dataRepositoryImpls {
                let dataSourceName = dataSourceMatch(for: element.name, state: state)
                try write(Templates.repositoryImpl(name: element.name, dataSourceName: dataSourceName), to: dir.appendingPathComponent("\(element.name)RepositoryImpl.swift"))
            }
        }
        if !state.dataDTOs.isEmpty {
            let dir = dataDir.appendingPathComponent("DTO")
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            for element in state.dataDTOs {
                try write(Templates.dto(name: element.name), to: dir.appendingPathComponent("\(element.name)DTO.swift"))
            }
        }
        if !state.dataDataSources.isEmpty {
            let dir = dataDir.appendingPathComponent("DataSource")
            try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            for element in state.dataDataSources {
                try write(Templates.dataSource(name: element.name), to: dir.appendingPathComponent("\(element.name)DataSource.swift"))
            }
        }
    }

    private static func generatePresentation(state: WizardState, sourcesDir: URL, appName: String, log: (String) -> Void) throws {
        let fm = FileManager.default
        let presentationDir = sourcesDir.appendingPathComponent("Presentation")
        try fm.createDirectory(at: presentationDir, withIntermediateDirectories: true)

        guard !state.presentationScreens.isEmpty else {
            log(L("log.no_screens"))
            return
        }

        let appDir = presentationDir.appendingPathComponent("App")
        try fm.createDirectory(at: appDir, withIntermediateDirectories: true)

        let entryScreen = state.presentationScreens.first(where: { $0.name == "Main" })?.name ?? state.presentationScreens[0].name

        switch (state.uiFramework, state.presentationPattern) {
        case (.swiftUI, .tca):
            try write(Templates.swiftUITCAApp(appName: appName, entryScreen: entryScreen), to: appDir.appendingPathComponent("\(appName)App.swift"))
        case (.swiftUI, _):
            try write(Templates.swiftUIApp(appName: appName, entryScreen: entryScreen), to: appDir.appendingPathComponent("\(appName)App.swift"))
        case (.uikit, _):
            try write(Templates.uikitAppDelegate(entryScreen: entryScreen), to: appDir.appendingPathComponent("AppDelegate.swift"))
        }

        for screen in state.presentationScreens {
            let screenDir = presentationDir.appendingPathComponent(screen.name)
            try fm.createDirectory(at: screenDir, withIntermediateDirectories: true)
            let useCaseName = useCaseMatch(for: screen.name, state: state)

            switch (state.uiFramework, state.presentationPattern) {
            case (.swiftUI, .mvvm):
                try write(Templates.swiftUIView(name: screen.name), to: screenDir.appendingPathComponent("\(screen.name)View.swift"))
                try write(Templates.viewModel(name: screen.name, useCaseName: useCaseName), to: screenDir.appendingPathComponent("\(screen.name)ViewModel.swift"))
            case (.swiftUI, .mvvmC):
                try write(Templates.swiftUIView(name: screen.name), to: screenDir.appendingPathComponent("\(screen.name)View.swift"))
                try write(Templates.viewModel(name: screen.name, useCaseName: useCaseName), to: screenDir.appendingPathComponent("\(screen.name)ViewModel.swift"))
                try write(Templates.coordinator(name: screen.name), to: screenDir.appendingPathComponent("\(screen.name)Coordinator.swift"))
            case (.swiftUI, .tca):
                try write(Templates.tcaFeature(name: screen.name), to: screenDir.appendingPathComponent("\(screen.name)Feature.swift"))
                try write(Templates.tcaView(name: screen.name), to: screenDir.appendingPathComponent("\(screen.name)View.swift"))
            case (.uikit, .mvvm):
                try write(Templates.uikitViewController(name: screen.name), to: screenDir.appendingPathComponent("\(screen.name)ViewController.swift"))
                try write(Templates.viewModel(name: screen.name, useCaseName: useCaseName), to: screenDir.appendingPathComponent("\(screen.name)ViewModel.swift"))
            case (.uikit, .mvvmC):
                try write(Templates.uikitViewController(name: screen.name), to: screenDir.appendingPathComponent("\(screen.name)ViewController.swift"))
                try write(Templates.viewModel(name: screen.name, useCaseName: useCaseName), to: screenDir.appendingPathComponent("\(screen.name)ViewModel.swift"))
                try write(Templates.coordinator(name: screen.name), to: screenDir.appendingPathComponent("\(screen.name)Coordinator.swift"))
            case (.uikit, .tca):
                // UIKit + TCA is not offered in the pattern picker; guarded there.
                break
            }
        }
    }

    /// Builds a composition-root DIContainer with a factory method per generated type.
    /// Only wired via constructor injection when `repositoryMatch`/`dataSourceMatch`/`useCaseMatch`
    /// found a same-named counterpart in the adjacent layer; otherwise falls back to a bare init,
    /// so every factory method is always guaranteed to compile.
    private static func generateDIContainer(state: WizardState, sourcesDir: URL) throws {
        guard state.presentationPattern != .tca else {
            // TCA manages its own dependencies via swift-dependencies; no container needed.
            return
        }
        guard !state.presentationScreens.isEmpty else { return }

        var body = ""

        for element in state.dataDataSources {
            body += "\n    func make\(element.name)DataSourceImpl() -> \(element.name)DataSourceImpl {\n        \(element.name)DataSourceImpl()\n    }\n"
        }

        for element in state.dataRepositoryImpls {
            let dataSourceName = dataSourceMatch(for: element.name, state: state)
            let call = dataSourceName.map { "\(element.name)RepositoryImpl(dataSource: make\($0)DataSourceImpl())" } ?? "\(element.name)RepositoryImpl()"
            body += "\n    func make\(element.name)RepositoryImpl() -> \(element.name)RepositoryImpl {\n        \(call)\n    }\n"
        }

        for element in state.domainUseCases {
            let repositoryName = repositoryMatch(for: element.name, state: state)
            let call = repositoryName.map { "\(element.name)UseCase(repository: make\($0)RepositoryImpl())" } ?? "\(element.name)UseCase()"
            body += "\n    func make\(element.name)UseCase() -> \(element.name)UseCase {\n        \(call)\n    }\n"
        }

        for screen in state.presentationScreens {
            let useCaseName = useCaseMatch(for: screen.name, state: state)
            let viewModelCall = useCaseName.map { "\(screen.name)ViewModel(useCase: make\($0)UseCase())" } ?? "\(screen.name)ViewModel()"
            body += "\n    func make\(screen.name)ViewModel() -> \(screen.name)ViewModel {\n        \(viewModelCall)\n    }\n"

            switch state.uiFramework {
            case .swiftUI:
                body += "\n    func make\(screen.name)View() -> \(screen.name)View {\n        \(screen.name)View(viewModel: make\(screen.name)ViewModel())\n    }\n"
            case .uikit:
                body += "\n    func make\(screen.name)ViewController() -> \(screen.name)ViewController {\n        \(screen.name)ViewController(viewModel: make\(screen.name)ViewModel())\n    }\n"
            }
        }

        let dir = sourcesDir.appendingPathComponent("DI")
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        let content = Templates.diContainerHeader().replacingOccurrences(of: "private init() {}", with: "private init() {}\n\(body)")
        try write(content, to: dir.appendingPathComponent("DIContainer.swift"))
    }

    private static func write(_ content: String, to url: URL) throws {
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
}
