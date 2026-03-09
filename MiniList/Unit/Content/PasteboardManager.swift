//
//  PasteboardManager.swift
//  MiniList
//
//  Created by Anton Cherkasov on 04.03.2026.
//

import Foundation
import CoreTransferable
import UniformTypeIdentifiers

struct PasteboardManager {

	func lines(from providers: [NSItemProvider]) async -> [Line] {
		var result: [Line] = []

		for provider in providers {
			guard let string = await string(from: provider) else {
				continue
			}

			let lines = await TextProcessor().parseLines(from: string)
			result.append(contentsOf: lines)
		}
		return result
	}

	func providers(for lines: [Line]) -> [NSItemProvider] {
		return lines.map { line in
			let provider = NSItemProvider()
			provider.register(line)
			return provider
		}
	}

	func hasData(in providers: [NSItemProvider]) -> Bool {
		providers.contains { provider in
			let type = UTType.plainText.identifier
			return provider.hasItemConformingToTypeIdentifier(type)
		}
	}

	func filtered(providers: [NSItemProvider]) -> [NSItemProvider] {
		providers.filter {
			let type = UTType.plainText.identifier
			return $0.hasItemConformingToTypeIdentifier(type)
		}
	}
}

// MARK: - Helpers
private extension PasteboardManager {

	func string(from provider: NSItemProvider) async -> String? {
		await withCheckedContinuation { continuation in
			_ = provider.loadObject(ofClass: NSString.self) { object, _ in
				continuation.resume(returning: object as? String)
			}
		}
	}
}
