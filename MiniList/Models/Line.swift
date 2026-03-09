//
//  Line.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import Foundation
import CoreTransferable

struct Line {

	let uuid: UUID
	var isCompleted: Bool
	var text: String
	var iconName: IconName?
	var iconColor: IconColor?

	// MARK: - Initialization

	nonisolated init(
		uuid: UUID = UUID(),
		isCompleted: Bool = false,
		text: String,
		iconName: IconName = .none,
		iconColor: IconColor = .secondary
	) {
		self.uuid = uuid
		self.isCompleted = isCompleted
		self.text = text
		self.iconName = iconName
		self.iconColor = iconColor
	}
}

// MARK: - Codable
extension Line: Codable { }

// MARK: - Transferable
extension Line: Transferable {

	static var transferRepresentation: some TransferRepresentation {
		ProxyRepresentation { line in
			TextProcessor().format([line])
		}
	}
}

// MARK: - Hashable
extension Line: Hashable { }

// MARK: - Identifiable
extension Line: Identifiable {

	var id: UUID {
		uuid
	}
}
