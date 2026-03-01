//
//  ListDocument.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI
import UniformTypeIdentifiers

nonisolated struct ListDocument: FileDocument {

	// MARK: - Data

	var content: ListContent

	// MARK: - Initialization

	init(lines: [Line] = []) {
		self.content = .init(lines: lines)
	}

	static let readableContentTypes = [
		UTType(importedAs: "dev.zeroindex.minilist")
	]

	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents else {
			throw CocoaError(.fileReadCorruptFile)
		}
		self.content = try JSONDecoder().decode(ListContent.self, from: data)
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let data = try JSONEncoder().encode(content)
		return .init(regularFileWithContents: data)
	}
}
