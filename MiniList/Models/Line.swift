//
//  Line.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct Line {

	let uuid: UUID
	var isCompleted: Bool
	var isMarked: Bool?
	var text: String

	// MARK: - Initialization

	nonisolated init(uuid: UUID = UUID(), isCompleted: Bool, isMarked: Bool? = nil, text: String) {
		self.uuid = uuid
		self.isCompleted = isCompleted
		self.isMarked = isMarked
		self.text = text
	}
}

// MARK: - Codable
extension Line: Codable { }

// MARK: - Transferable
extension Line: Transferable {

	static var transferRepresentation: some TransferRepresentation {
		CodableRepresentation(contentType: .line)
		ProxyRepresentation(exporting: \.text)
	}
}

// MARK: - Identifiable
extension Line: Identifiable {

	var id: UUID {
		uuid
	}
}
// MARK: - UTType
extension UTType {

	static let line = UTType(exportedAs: "dev.zeroindex.minilist.line")
}
