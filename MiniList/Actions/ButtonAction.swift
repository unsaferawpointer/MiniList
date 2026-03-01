//
//  ButtonAction.swift
//  MiniList
//
//  Created by Anton Cherkasov on 01.03.2026.
//

struct ButtonAction<T> {

	let title: String
	let imageName: String
	let isEnabled: Bool
	let onPerform: () -> Void
}
