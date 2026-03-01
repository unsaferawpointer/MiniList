//
//  Line.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import Foundation

struct Line {

	let uuid: UUID
	var isCompleted: Bool
	var text: String

	// MARK: - Initialization

	nonisolated init(uuid: UUID = UUID(), isCompleted: Bool, text: String) {
		self.uuid = uuid
		self.isCompleted = isCompleted
		self.text = text
	}
}

// MARK: - Identifiable
extension Line: Identifiable {

	var id: UUID {
		uuid
	}
}
