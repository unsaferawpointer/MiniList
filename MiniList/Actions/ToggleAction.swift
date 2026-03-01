//
//  ToggleAction.swift
//  MiniList
//
//  Created by Anton Cherkasov on 01.03.2026.
//

import SwiftUI

struct ToggleAction<T> {

	let title: String
	let source: [Binding<Bool>]
	let isEnabled: Bool
}
