//
//  LineView.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI

struct LineView {

	@Binding var line: Line

	// MARK: - Local State

	@FocusState private var focus: Bool

	@State private var text: String

	// MARK: - Initialization

	init(line: Binding<Line>) {
		self._line = line
		self._text = State(initialValue: line.wrappedValue.text)
	}
}

// MARK: - View
extension LineView: View {

	var body: some View {
		HStack(alignment: .firstTextBaseline) {
			(line.iconName ?? .none).image
				.foregroundStyle(.tertiary)
				.font(.footnote)
			TextField(ContentStrings.Line.requiredPlaceholder, text: $text)
				.foregroundStyle(line.isCompleted ? .tertiary : .primary)
				.font(.body)
				.focused($focus)
				.onSubmit {
					onChange(newValue: text)
				}
				.onChange(of: focus) {
					onChange(newValue: text)
				}
				.onChange(of: line.text) { oldValue, newValue in
					text = newValue
				}
		}
	}
}

// MARK: - Helpers
private extension LineView {

	func onChange(newValue: String) {
		line.text = newValue
	}
}

#Preview {
	LineView(line: .constant(.init(isCompleted: false, text: "Line")))
}
