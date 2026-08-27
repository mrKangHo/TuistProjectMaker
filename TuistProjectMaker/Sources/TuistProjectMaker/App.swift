import SwiftUI

@main
struct TuistProjectMakerApp: App {
    @StateObject private var state = WizardState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
                .frame(minWidth: 720, minHeight: 480)
        }
        .windowResizability(.contentSize)
    }
}
