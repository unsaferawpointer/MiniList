//
//  ContentView.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI

struct ContentView: View {
	
	@Binding var document: ListDocument

	@State private var selection: Set<UUID> = []
	
	var body: some View {
		NavigationStack {
			List(selection: $selection) {
				ForEach($document.content.lines) { $line in
					LineView(line: $line)
						.listRowSeparator(.hidden)
						.listRowInsets(.horizontal, 8)
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
			.toolbar {
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
		}
	}
}

// MARK: - Binding
extension ContentView {

	func sources(for selected: Set<UUID>) -> [Binding<Bool>] {
		document.content.lines.indices.compactMap { index in
			guard selected.contains(document.content.lines[index].id) else {
				return nil
			}
			return Binding {
				document.content.lines[index].isCompleted
			} set: { newValue in
				document.content.lines[index].isCompleted = newValue
			}
		}
	}
}

#Preview {
	ContentView(document: .constant(ListDocument()))
}
