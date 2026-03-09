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
