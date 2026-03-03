//
//  ListDocument.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ListDocument: FileDocument {

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

// MARK: - Subscript
extension ListDocument {

	subscript(_ index: Int) -> Line {
		get {
			content.lines[index]
		}
		set {
			content.lines[index] = newValue
		}
	}
}

extension ListDocument {

	var isEmpty: Bool {
		content.lines.isEmpty
	}
}

extension ListDocument {

	@discardableResult
	mutating func insertText(_ strings: [String], to target: Int?) -> Bool {
		let texts = strings
			.flatMap { value in
				value
					.split(whereSeparator: \.isNewline)
					.map(String.init)
					.filter {
						!$0.isEmpty
					}
			}

		let newLines = texts.map { text in
			Line(isCompleted: false, text: text)
		}

		guard let target else {
			content.lines.append(contentsOf: newLines)
			return true
		}

		content.lines.insert(contentsOf: newLines, at: target)
		return true
	}
}

extension ListDocument {

	mutating func deleteLines(ids: Set<UUID>) {
		guard !ids.isEmpty else {
			return
		}
		content.lines.removeAll { line in
			ids.contains(line.id)
		}
	}

	mutating func deleteLines(with indices: IndexSet) {
		content.lines.remove(atOffsets: indices)
	}

	@discardableResult
	mutating func insertLine(with text: String) -> UUID {
		let newLine = Line(isCompleted: false, text: text)
		content.lines.append(newLine)
		return newLine.id
	}

	mutating func updateText(for id: UUID, newValue: String) {
		guard let index = content.lines.firstIndex(where: { $0.id == id }) else {
			return
		}
		content.lines[index].text = newValue
	}

	mutating func moveLines(indices: IndexSet, to target: Int) {
		guard !indices.isEmpty else {
			return
		}
		content.lines.move(fromOffsets: indices, toOffset: target)
	}
}
