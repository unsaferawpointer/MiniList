//
//  MiniListApp.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI

@main
struct MiniListApp: App {

	@FocusedValue(\.addAction) private var addAction
	@FocusedValue(\.deleteAction) private var deleteAction
	@FocusedValue(\.completionAction) private var completionAction

	var body: some Scene {
		DocumentGroup(newDocument: ListDocument()) { file in
			ContentView(document: file.$document)
		}
			.commands {
				CommandMenu("Editor") {
					if let action = addAction {
						Button {
							action.onPerform()
						} label: {
							Label(action.title, systemImage: action.imageName)
						}
						.keyboardShortcut(.return, modifiers: [.command, .option])
						.disabled(!action.isEnabled)
					}
					Divider()
					if let action = completionAction {
						Toggle(sources: action.source, isOn: \.self) {
							Text(action.title)
						}
					.keyboardShortcut(.return, modifiers: [.command])
					.disabled(!action.isEnabled)
				}
				Divider()
				if let action = deleteAction {
					Button(role: .destructive) {
						action.onPerform()
					} label: {
						Label(action.title, systemImage: action.imageName)
					}
					.keyboardShortcut(.delete)
					.disabled(!action.isEnabled)
				}
			}
		}
	}
}
