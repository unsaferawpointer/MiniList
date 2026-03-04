//
//  ContentStrings.swift
//  MiniList
//
//  Created by Codex on 04.03.2026.
//

import Foundation

enum ContentStrings {

	enum Action {
		static let addTitle = String(localized: "action.add", table: "ContentLocalizable")
		static let newItemTitle = String(localized: "action.new_item", table: "ContentLocalizable")
		static let deleteTitle = String(localized: "action.delete", table: "ContentLocalizable")
		static let completedTitle = String(localized: "action.completed", table: "ContentLocalizable")
	}

	enum Placeholder {
		enum Empty {
			static let title = String(localized: "placeholder.empty.title", table: "ContentLocalizable")
			static let message = String(localized: "placeholder.empty.message", table: "ContentLocalizable")
		}

		enum Drop {
			static let title = String(localized: "placeholder.drop.title", table: "ContentLocalizable")
			static let message = String(localized: "placeholder.drop.message", table: "ContentLocalizable")
		}
	}

	enum Line {
		static let requiredPlaceholder = String(localized: "line.required", table: "ContentLocalizable")
	}
}
