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

	var body: some View {
		NavigationStack {
			List(selection: $selection) {
				ForEach($document.content.lines) { $line in
					LineView(line: $line)
						.listRowSeparator(.hidden)
						.listRowInsets(.horizontal, 8)
						.listRowInsets(.vertical, 6)
						.draggable(line.text)
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
				.onInsert(of: [.plainText]) { target, providers in
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
				\.deleteAction,
				 ButtonAction(
					title: "Delete",
					imageName: "trash",
					isEnabled: !selection.isEmpty
				 ) {
					 document.deleteLines(ids: selection)
				 }
			)
			.focusedValue(
				\.completionAction,
				 ToggleAction(
					title: "Completed",
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
			Text("Completed")
		}
		.disabled(selected.isEmpty)
		Divider()
		Button(role: .destructive) {
			document.deleteLines(ids: selected)
		} label: {
			Label("Delete", systemImage: "trash")
		}
	}

	@ToolbarContentBuilder
	func buildToolbar() -> some ToolbarContent {
		ToolbarItem(placement: .primaryAction) {
			Button {
				withAnimation {
					_ = document.insertLine(with: "New Item")
				}
			} label: {
				Label("Add", systemImage: "plus")
			}
		}
	}

	@ViewBuilder
	func buildPlaceholder() -> some View {
		ContentUnavailableView(
			isPlaceholderDropTargeted ? "Drop to Add Items" : "List is Empty",
			systemImage: isPlaceholderDropTargeted ? "square.and.arrow.down" : "checklist",
			description: Text(
				isPlaceholderDropTargeted
				? "Release to add text as new items."
				: "Add your first item to get started."
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
			let strings = await strings(from: providers)
			document.insertText(strings, to: target)
		}
	}

	func strings(from providers: [NSItemProvider]) async -> [String] {
		await withTaskGroup(of: String?.self, returning: [String].self) { group in
			for provider in providers {
				group.addTask {
					return await withCheckedContinuation { continuation in
						_ = provider.loadObject(ofClass: NSString.self) { object, _ in
							continuation.resume(returning: object as? String)
						}
					}
				}
			}

			var result: [String?] = []
			for await value in group {
				result.append(value)
			}

			return result.compactMap(\.self)
		}
	}
}

#Preview {
	ContentView(document: .constant(ListDocument()))
}
