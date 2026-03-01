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
				ForEach($document.lines) { $line in
					LineView(line: $line)
						.listRowSeparator(.hidden)
						.listRowInsets(.horizontal, 8)
						.id(line.id)
				}
				.onMove { indices, target in
					document.lines.move(fromOffsets: indices, toOffset: target)
				}
				.onDelete { indices in
					withAnimation {
						document.lines.remove(atOffsets: indices)
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
					 deleteSelected(for: selection)
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
					deleteSelected(for: selected)
				} label: {
					Label("Delete", systemImage: "trash")
				}
			}
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button {
						let new = Line(isCompleted: false, text: "New")
						withAnimation {
							document.lines.append(new)
						}
					} label: {
						Label("Add", systemImage: "plus")
					}
				}
			}
		}
	}
}

extension ContentView {
	func sources(for selected: Set<UUID>) -> [Binding<Bool>] {
		document.lines.indices.compactMap { index in
			guard selected.contains(document.lines[index].id) else {
				return nil
			}
			return Binding {
				document.lines[index].isCompleted
			} set: { newValue in
				document.lines[index].isCompleted = newValue
			}
		}
	}
	
	func toggleCompleted(for selected: Set<UUID>) {
		guard !selected.isEmpty else {
			return
		}
		
		let selectedIndices = document.lines.indices.filter { index in
			selected.contains(document.lines[index].id)
		}
		let isAllCompleted = selectedIndices.allSatisfy { index in
			document.lines[index].isCompleted
		}
		let newValue = !isAllCompleted
		
		withAnimation {
			selectedIndices.forEach { index in
				document.lines[index].isCompleted = newValue
			}
		}
	}
	
	func deleteSelected(for selected: Set<UUID>) {
		guard !selected.isEmpty else {
			return
		}
		
		withAnimation {
			document.lines.removeAll {
				selected.contains($0.id)
			}
		}
	}
}

#Preview {
	ContentView(document: .constant(ListDocument()))
}
