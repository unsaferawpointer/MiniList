//
//  PlaceholderView.swift
//  MiniList
//
//  Created by Anton Cherkasov on 09.03.2026.
//

import SwiftUI

struct PlaceholderView: View {

	let imageName: String

	let title: String

	let message: String

	@Binding var isTargeted: Bool

	var body: some View {
		VStack(spacing: 8) {
			Image(systemName: imageName)
			.font(.system(size: 46, weight: .regular))
			.foregroundStyle(.tertiary)
			.contentTransition(.symbolEffect(.automatic))
			.animation(
				.spring(
					response: 0.28,
					dampingFraction: 0.86
				),
				value: isTargeted
			)
			VStack(spacing: 4) {
				Text(title)
					.foregroundStyle(.primary)
					.font(.title2)
					.fontWeight(.semibold)
				Text(message)
				.foregroundStyle(.secondary)
				.font(.body)
			}

		}
		.multilineTextAlignment(.center)
		.padding(24)
		.accessibilityIdentifier("empty-list-placeholder")
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background {
			if isTargeted {
				RoundedRectangle(cornerRadius: 14, style: .continuous)
					.fill(Color.accentColor.opacity(0.08))
					.padding(16)
			}
		}
		.overlay {
			RoundedRectangle(cornerRadius: 14, style: .continuous)
				.stroke(
					isTargeted ? Color.accentColor : Color.clear,
					lineWidth: 2
				)
				.padding(16)
		}
	}
}

#Preview {
	PlaceholderView(
		imageName: "folder",
		title: "Title",
		message: "Message",
		isTargeted: .constant(false)
	)
}

#Preview {
	PlaceholderView(
		imageName: "folder",
		title: "Title",
		message: "Message",
		isTargeted: .constant(true)
	)
}
