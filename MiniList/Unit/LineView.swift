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
		HStack {
			Circle()
				.foregroundStyle(.tertiary)
				.frame(width: 4, height: 4)
			TextField("Required", text: $text)
				.foregroundStyle(line.isCompleted ? .tertiary : .primary)
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
