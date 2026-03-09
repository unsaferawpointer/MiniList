//
//  ContentModel.swift
//  MiniList
//
//  Created by Anton Cherkasov on 09.03.2026.
//

import SwiftUI

@Observable
@MainActor final class ContentModel {

	var selection: Set<UUID> = []
	var isTargeted = false

	@ObservationIgnored
	let dropManager = PasteboardManager()

	@ObservationIgnored
	let textProcessor = TextProcessor()
}

extension ContentModel {

	func loadLines(from providers: [NSItemProvider]) async -> [Line] {
		await dropManager.lines(from: providers)
	}

	func providers(in document: ListDocument) -> [NSItemProvider] {
		let lines = document.content.lines.filter {
			selection.contains($0.id)
		}
		return dropManager.providers(for: lines)
	}
}

// MARK: - Binding
extension ContentModel {

	func completionSources(for selected: Set<UUID>, in document: Binding<ListDocument>) -> [Binding<Bool>] {
		document.content.lines.indices.compactMap { index -> Binding<Bool>? in
			guard selected.contains(document[index].id) else {
				return nil
			}
			return Binding {
				document[index].wrappedValue.isCompleted
			} set: { newValue in
				document[index].wrappedValue.isCompleted = newValue
			}
		}
	}
}

extension ContentModel {

	func set(iconName: IconName, for selected: Set<UUID>, in document: Binding<ListDocument>) {
		guard !selected.isEmpty else {
			return
		}
		for index in document.content.lines.indices {
			guard selected.contains(document[index].id) else {
				continue
			}
			document[index].wrappedValue.iconName = iconName
		}
	}

	func set(iconColor: IconColor, for selected: Set<UUID>, in document: Binding<ListDocument>) {
		guard !selected.isEmpty else {
			return
		}
		for index in document.content.lines.indices {
			guard selected.contains(document[index].id) else {
				continue
			}
			document[index].wrappedValue.iconColor = iconColor
		}
	}
}

extension ContentModel {

	func clearSelection() {
		selection.removeAll()
	}
}

extension ContentModel {

	var isDeletionAvailable: Bool {
		!selection.isEmpty
	}

	var isCompletionAvailable: Bool {
		!selection.isEmpty
	}

	var canCopy: Bool {
		!selection.isEmpty
	}
}
