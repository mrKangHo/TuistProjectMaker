import SwiftUI

struct ElementListEditor: View {
    let title: String
    let placeholder: String
    @Binding var elements: [NamedElement]
    var disabled: Bool = false

    @State private var newName: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            if elements.isEmpty {
                Text(L("element_editor.empty"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(elements) { element in
                    HStack {
                        Text(element.name)
                        Spacer()
                        Button {
                            elements.removeAll { $0.id == element.id }
                        } label: {
                            Image(systemName: "trash")
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(.red)
                    }
                }
            }

            HStack {
                TextField(placeholder, text: $newName)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit(add)
                Button(L("element_editor.add"), action: add)
                    .disabled(newName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .padding(12)
        .background(.quaternary.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .disabled(disabled)
        .opacity(disabled ? 0.4 : 1)
    }

    private func add() {
        let trimmed = newName.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        elements.append(NamedElement(name: trimmed))
        newName = ""
    }
}
