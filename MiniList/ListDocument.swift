//
//  ListDocument.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI
import UniformTypeIdentifiers

nonisolated struct ListDocument: FileDocument {

	var lines: [Line]

	init(lines: [Line] = []) {
		self.lines = lines
	}

	static let readableContentTypes = [
		UTType(importedAs: "dev.zeroindex.mini-list")
	]

	init(configuration: ReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents,
			  let string = String(data: data, encoding: .utf8)
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		var result: [Line] = []
		string.enumerateLines { text, stop in
			let line = Line(isCompleted: false, text: text)
			result.append(line)
		}
		self.lines = result
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let text = lines.map(\.text).joined(separator: "\n")
		let data = text.data(using: .utf8)!
		return .init(regularFileWithContents: data)
	}
}
