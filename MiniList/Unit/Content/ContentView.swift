//
//  ContentView.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {

	@Binding var document: ListDocument

	@State private var selection: Set<UUID> = []
	@State private var isPlaceholderDropTargeted = false

	private let dropManager = DropManager()

	var body: some View {
		NavigationStack {
				List(selection: $selection) {
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
				.onDelete { indices in
					withAnimation {
						document.deleteLines(with: indices)
					}
				}
				.onInsert(of: [.line, .plainText]) { target, providers in
					handleDrop(target: target, providers: providers)
				}
			}
			.onCopyCommand {
				copy()
			}
			.onCutCommand {
				cut()
			}
			.onPasteCommand(of: [.plainText]) { providers in
				paste(providers: providers)
			}
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
					isEnabled: !selection.isEmpty
				 ) {
					 document.deleteLines(ids: selection)
				 }
			)
			.focusedValue(
				\.completionAction,
				 ToggleAction(
					title: ContentStrings.Action.completedTitle,
					source: sources(for: selection),
					isEnabled: !selection.isEmpty
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
		ContentUnavailableView(
			isPlaceholderDropTargeted ? ContentStrings.Placeholder.Drop.title : ContentStrings.Placeholder.Empty.title,
			systemImage: isPlaceholderDropTargeted ? "square.and.arrow.down" : "checklist",
			description: Text(
				isPlaceholderDropTargeted
				? ContentStrings.Placeholder.Drop.message
				: ContentStrings.Placeholder.Empty.message
			)
		)
		.accessibilityIdentifier("empty-list-placeholder")
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		.background {
			if isPlaceholderDropTargeted {
				RoundedRectangle(cornerRadius: 14, style: .continuous)
					.fill(.blue.opacity(0.08))
					.padding(16)
			}
		}
		.overlay {
			RoundedRectangle(cornerRadius: 14, style: .continuous)
				.stroke(
					isPlaceholderDropTargeted ? Color.blue : Color.clear,
					lineWidth: 2
				)
				.padding(16)
		}
		.dropDestination(for: String.self) { items, _ in
			withAnimation {
				_ = document.insertText(items, to: nil)
			}
			return true
		} isTargeted: { isTargeted in
			withAnimation(.easeInOut(duration: 0.12)) {
				isPlaceholderDropTargeted = isTargeted
			}
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
		let strings = document.content.lines
			.filter { selection.contains($0.id) }
			.map(\.text)

		return strings.map {
			NSItemProvider(object: $0 as NSString)
		}
	}

	func cut() -> [NSItemProvider] {
		let providers = copy()
		guard !providers.isEmpty else {
			return []
		}
		withAnimation {
			document.deleteLines(ids: selection)
			selection.removeAll()
		}
		return providers
	}

	func paste(providers: [NSItemProvider]) {
		var max: Int?
		for (index, line) in document.content.lines.enumerated().reversed() {
			guard selection.contains(line.id) else {
				continue
			}
			max = index
			break
		}
		pasteProviders(providers, at: max)
	}
}

// MARK: - Drop Support
private extension ContentView {

	func handleDrop(target: Int, providers: [NSItemProvider]) {
		pasteProviders(providers, at: target)
	}

	func pasteProviders(_ providers: [NSItemProvider], at target: Int?) {
		Task { @MainActor in
			let lines = await dropManager.lines(from: providers)
			document.insertLines(lines, to: target)
		}
	}
}

#Preview {
	ContentView(document: .constant(ListDocument()))
}
