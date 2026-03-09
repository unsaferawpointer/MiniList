//
//  ContentView.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import CoreTransferable
#if os(macOS)
import AppKit
#endif

struct ContentView: View {

	@Binding var document: ListDocument

	@Bindable var model = ContentModel()

	var body: some View {
		List(selection: $model.selection) {
			ForEach($document.content.lines) { $line in
				LineView(line: $line)
					.listRowSeparator(.hidden)
					.listRowInsets(.horizontal, 8)
					.listRowInsets(.vertical, 6)
					.draggable(line)
			}
			.onMove { indices, target in
				withAnimation {
					document.moveLines(indices: indices, to: target)
				}
			}
			.onInsert(of: [.plainText]) { target, providers in
				_ = handleDrop(providers, to: target)
			}
		}
		.onCopyCommand(perform: model.canCopy ? { copy() } : nil)
		.onCutCommand(perform: model.canCopy ? { cut() } : nil)
		.onPasteCommand(
			of: [.plainText],
			perform: { providers in
				paste(providers: providers)
			}
		)
		.focusedValue(
			\.addAction,
			 ButtonAction(
				title: ContentStrings.Action.newItemTitle,
				imageName: "plus",
				isEnabled: true
			 ) {
				 withAnimation {
					 _ = document.insertLine(with: ContentStrings.Action.newItemTitle)
				 }
			 }
		)
		.focusedValue(
			\.deleteAction,
			 ButtonAction(
				title: ContentStrings.Action.deleteTitle,
				imageName: "trash",
				isEnabled: model.isDeletionAvailable
			 ) {
				 document.deleteLines(ids: model.selection)
			 }
		)
		.focusedValue(
			\.completionAction,
			 ToggleAction(
				title: ContentStrings.Action.completedTitle,
				source: sources(for: model.selection),
				isEnabled: model.isCompletionAvailable
			 )
		)
		.contextMenu(forSelectionType: UUID.self) { selected in
			buildMenu(selected: selected)
		}
		.toolbar {
			buildToolbar()
		}
		.overlay {
			if document.isEmpty {
				buildPlaceholder()
			}
		}
	}
}

// MARK: - Builders
private extension ContentView {

	@ViewBuilder
	func buildMenu(selected: Set<UUID>) -> some View {
		Toggle(sources: sources(for: selected), isOn: \.self) {
			Text(ContentStrings.Action.completedTitle)
		}
		.disabled(selected.isEmpty)
		Divider()
		Button(role: .destructive) {
			document.deleteLines(ids: selected)
		} label: {
			Label(ContentStrings.Action.deleteTitle, systemImage: "trash")
		}
	}

	@ToolbarContentBuilder
	func buildToolbar() -> some ToolbarContent {
		ToolbarItem(placement: .primaryAction) {
			Button {
				withAnimation {
					_ = document.insertLine(with: ContentStrings.Action.newItemTitle)
				}
			} label: {
				Label(ContentStrings.Action.addTitle, systemImage: "plus")
			}
		}
	}

	@ViewBuilder
	func buildPlaceholder() -> some View {
		PlaceholderView(
			imageName:
				model.isTargeted
			? "square.and.arrow.down"
			: "list.bullet.rectangle.portrait",
			title:
				model.isTargeted
			? ContentStrings.Placeholder.Drop.title
			: ContentStrings.Placeholder.Empty.title,
			message:
				model.isTargeted
			? ContentStrings.Placeholder.Drop.message
			: ContentStrings.Placeholder.Empty.message,
			isTargeted: $model.isTargeted
		)
		.onDrop(of: [.plainText], isTargeted: $model.isTargeted) { providers in
			return handleDrop(providers, to: nil)
		}
	}
}

// MARK: - Binding
private extension ContentView {

	func sources(for selected: Set<UUID>) -> [Binding<Bool>] {
		document.content.lines.indices.compactMap { index in
			guard selected.contains(document[index].id) else {
				return nil
			}
			return Binding {
				document[index].isCompleted
			} set: { newValue in
				document[index].isCompleted = newValue
			}
		}
	}
}

// MARK: - Copy / Paste Support
private extension ContentView {

	func copy() -> [NSItemProvider] {
		return model.providers(in: document)
	}

	func cut() -> [NSItemProvider] {
		let providers = copy()
		withAnimation {
			document.deleteLines(ids: model.selection)
			model.clearSelection()
		}
		return providers
	}

	func paste(providers: [NSItemProvider]) {
		var max: Int?
		for (index, line) in document.content.lines.enumerated().reversed() {
			guard model.selection.contains(line.id) else {
				continue
			}
			max = index
			break
		}
		handleDrop(providers, to: max)
	}

	var selectedLines: [Line] {
		document.content.lines.filter { model.selection.contains($0.id) }
	}

	@discardableResult
	func handleDrop(_ providers: [NSItemProvider], to target: Int?) -> Bool {
		Task { @MainActor in
			let lines = await model.loadLines(from: providers)
			withAnimation {
				_ = document.insertLines(lines, to: target)
			}
		}
		return true
	}
}

#Preview {
	ContentView(document: .constant(ListDocument()))
}
