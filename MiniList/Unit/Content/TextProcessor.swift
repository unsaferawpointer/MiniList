//
//  TextProcessor.swift
//  MiniList
//
//  Created by Anton Cherkasov on 08.03.2026.
//

import Foundation
import RegexBuilder

protocol LineParser {
	func parseLines(from text: String) async throws -> [Line]
}

protocol LineFormatter {
	func format(_ lines: [Line]) -> String
}

final class TextProcessor { }

// MARK: - LineParser
extension TextProcessor: LineParser {

	func parseLine(from lineText: String) -> Line? {
		let regex = Regex {
			ZeroOrMore(.whitespace)
			Capture {
				Optionally {
					ChoiceOf {
						"\(Prefix.regular.rawValue)"
						"\(Prefix.xmark.rawValue)"
					}
					OneOrMore(.whitespace)
				}
			}
			Capture {
				OneOrMore(.any)
			}
		}
		guard let match = lineText.wholeMatch(of: regex) else {
			return nil
		}

		let body = String(match.2)
		let prefix = Prefix(rawValue: String(match.1).trimmingCharacters(in: .whitespaces))

		return switch prefix {
		case .xmark:
			Line(isCompleted: true, text: body)
		default:
			Line(text: body)
		}
	}

	func parseLines(from text: String) async -> [Line] {
		text
			.split(whereSeparator: \.isNewline)
			.compactMap { raw in
				parseLine(from: String(raw))
			}
	}
}

// MARK: - LineFormatter
extension TextProcessor: LineFormatter {

	func format(_ lines: [Line]) -> String {
		lines
			.map { line in
				let prefix = line.isCompleted ? "x" : "-"
				let text = line.text

				return [prefix, text].joined(separator: " ")
			}
			.joined(separator: "\n")
	}
}
