//
//  DropManager.swift
//  MiniList
//
//  Created by Anton Cherkasov on 04.03.2026.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct DropManager {

	func lines(from providers: [NSItemProvider]) async -> [Line] {
		var result: [Line] = []

		for provider in providers {
			if let line = await transferableLine(from: provider) {
				result.append(line)
				continue
			}

			guard let string = await string(from: provider) else {
				continue
			}

			let textLines = string
				.split(whereSeparator: \.isNewline)
				.map(String.init)
				.filter { !$0.isEmpty }

			result.append(
				contentsOf: textLines.map { text in
					Line(isCompleted: false, text: text)
				}
			)
		}

		return result
	}
}

// MARK: - Helpers
private extension DropManager {

	func string(from provider: NSItemProvider) async -> String? {
		await withCheckedContinuation { continuation in
			_ = provider.loadObject(ofClass: NSString.self) { object, _ in
				continuation.resume(returning: object as? String)
			}
		}
	}

	func transferableLine(from provider: NSItemProvider) async -> Line? {
		await withCheckedContinuation { continuation in
			_ = provider.loadTransferable(type: Line.self) { result in
				switch result {
				case .success(let line):
					continuation.resume(returning: line)
				case .failure:
					continuation.resume(returning: nil)
				}
			}
		}
	}
}
