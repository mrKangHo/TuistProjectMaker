import SwiftUI

struct ContentView: View {
    @EnvironmentObject var state: WizardState
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

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
                ZStack {
                    stepContent
                        .id(state.currentStep)
                        .transition(stepTransition)
                }
                .clipped()
                Divider()
                HStack {
                    Button(L("action.previous")) { advance(state.goBack) }
                        .buttonStyle(.pressable)
                        .disabled(state.currentStep == .projectSelect || state.isGenerating)
                    Spacer()
                    Button(completionLabel) {
                        if state.currentStep == .summary {
                            state.generateAndReveal()
                        } else {
                            advance(state.goNext)
                        }
                    }
                    .buttonStyle(.pressable)
                    .keyboardShortcut(.defaultAction)
                    .disabled(state.currentStep == .summary ? completionDisabled : !state.canAdvance)
                }
                .padding(16)
                .background(.bar)
            }
        }
    }

    /// Enter/exit share the same axis as the navigation direction, so a step that
    /// slides in from the right slides back out to the right — never a mismatched path.
    private var stepTransition: AnyTransition {
        guard !reduceMotion else { return .opacity }
        let edge: Edge = state.isMovingForward ? .trailing : .leading
        let oppositeEdge: Edge = state.isMovingForward ? .leading : .trailing
        return .asymmetric(
            insertion: .move(edge: edge).combined(with: .opacity),
            removal: .move(edge: oppositeEdge).combined(with: .opacity)
        )
    }

    private func advance(_ action: () -> Void) {
        withAnimation(reduceMotion ? .easeInOut(duration: 0.15) : .appleDefault) {
            action()
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
