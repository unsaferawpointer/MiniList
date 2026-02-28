//
//  ContentView.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI

struct ContentView: View {

	@Binding var document: ListDocument

	var body: some View {
		List {
			ForEach(0..<10) { index in
				Text("Todo Tod \(index)")
			}
		}
	}
}

#Preview {
	ContentView(document: .constant(ListDocument()))
}
