import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: WizardState

    var body: some View {
        NavigationSplitView {
            List(WizardStep.allCases) { step in
                HStack {
                    Image(systemName: icon(for: step))
                        .foregroundStyle(step == state.currentStep ? Color.accentColor : .secondary)
                    Text(step.title)
                        .fontWeight(step == state.currentStep ? .semibold : .regular)
                }
            }
            .navigationTitle("TuistProjectMaker")
        } detail: {
            VStack(spacing: 0) {
                stepContent
                Divider()
                HStack {
                    Button(L("action.previous")) { state.goBack() }
                        .disabled(state.currentStep == .projectSelect || state.isGenerating)
                    Spacer()
                    Button(completionLabel) {
                        if state.currentStep == .summary {
                            state.generateAndReveal()
                        } else {
                            state.goNext()
                        }
                    }
                    .keyboardShortcut(.defaultAction)
                    .disabled(state.currentStep == .summary ? completionDisabled : !state.canAdvance)
                }
                .padding(16)
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch state.currentStep {
        case .projectSelect:
            ProjectSelectView()
        case .projectName:
            ProjectNameView()
        case .projectSettings:
            ProjectSettingsView()
        case .environmentCheck:
            EnvironmentCheckView()
        case .domainConfig:
            DomainConfigView()
        case .dataConfig:
            DataConfigView()
        case .presentationConfig:
            PresentationConfigView()
        case .uiFramework:
            UIFrameworkView()
        case .presentationPattern:
            PresentationPatternView()
        case .summary:
            SummaryView()
        }
    }

    private var completionLabel: String {
        guard state.currentStep == .summary else { return L("action.next") }
        if state.isGenerating { return L("action.generating") }
        if state.generatedProjectURL != nil { return L("action.generated") }
        return L("action.finish")
    }

    private var completionDisabled: Bool {
        state.isGenerating || state.destinationURL == nil || state.generatedProjectURL != nil
    }

    private func icon(for step: WizardStep) -> String {
        if step.rawValue < state.currentStep.rawValue { return "checkmark.circle.fill" }
        if step == state.currentStep { return "arrow.right.circle.fill" }
        return "circle"
    }
}
