import XCTest

struct ContentPage {

	private let app: XCUIApplication

	init(app: XCUIApplication) {
		self.app = app
	}
}

// MARK: - Public Interface
extension ContentPage {

	@discardableResult
	func openNewDocumentIfNeeded() -> Self {
		let newDocumentButton = app.descendants(matching: .any)["NewDocumentButton"]

		if newDocumentButton.waitForExistence(timeout: 1) {
			newDocumentButton.tap()
		} else {
			app.activate()
			app.typeKey("n", modifierFlags: .command)
		}
		return self
	}

	@discardableResult
	func clearList() -> Self {
		guard !hasEmptyPlaceholder(timeout: 0.2) else {
			return self
		}

		let table = app.tables.firstMatch
		if table.waitForExistence(timeout: 1) {
			table.tap()
		}

		app.activate()
		app.typeKey("a", modifierFlags: .command)
		app.typeKey(XCUIKeyboardKey.delete.rawValue, modifierFlags: [.command])
		return self
	}

	func hasEmptyPlaceholder(timeout: TimeInterval = 3) -> Bool {
		let placeholder = app.descendants(matching: .any)["empty-list-placeholder"]
		return placeholder.waitForExistence(timeout: timeout)
	}

	func hasEmptyPlaceholderMessage(timeout: TimeInterval = 1) -> Bool {
		let placeholderMessage = app.staticTexts["Add your first item to get started."]
		return placeholderMessage.waitForExistence(timeout: timeout)
	}
}
