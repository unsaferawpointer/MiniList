//
//  LineView.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI

struct LineView {
	
	@Binding var line: Line
}

// MARK: - View
extension LineView: View {
	
	var body: some View {
		HStack {
			Circle()
				.foregroundStyle(.tertiary)
				.frame(width: 4, height: 4)
			TextField("Required", text: $line.text)
				.foregroundStyle(line.isCompleted ? .tertiary : .primary)
		}
	}
}

#Preview {
	LineView(line: .constant(.init(isCompleted: false, text: "Line")))
}
