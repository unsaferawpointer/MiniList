//
//  MiniListUITests.swift
//  MiniListUITests
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import XCTest

final class MiniListUITests: XCTestCase {

	override func setUpWithError() throws {
		// Put setup code here. This method is called before the invocation of each test method in the class.

		// In UI tests it is usually best to stop immediately when a failure occurs.
		continueAfterFailure = false

		// In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
	}

	override func tearDownWithError() throws {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	@MainActor
	func testExample() throws {
		// UI tests must launch the application that they test.
		let app = XCUIApplication()
		app.launch()

		// Use XCTAssert and related functions to verify your tests produce the correct results.
	}

	@MainActor
	func testEmptyListShowsPlaceholder() throws {
		let app = XCUIApplication()
		app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
		app.launch()
		let contentPage = ContentPage(app: app)
		contentPage
			.openNewDocumentIfNeeded()
			.clearList()

		XCTAssertTrue(
			contentPage.hasEmptyPlaceholder(),
			"Expected empty list placeholder to be visible on launch."
		)
		XCTAssertTrue(
			contentPage.hasEmptyPlaceholderMessage(),
			"Expected empty list placeholder description to be visible."
		)
	}

	@MainActor
	func testLaunchPerformance() throws {
		// This measures how long it takes to launch your application.
		measure(metrics: [XCTApplicationLaunchMetric()]) {
			XCUIApplication().launch()
		}
	}
}
