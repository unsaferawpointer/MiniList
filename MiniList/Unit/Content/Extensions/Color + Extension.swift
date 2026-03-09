//
//  Color + Extension.swift
//  MiniList
//
//  Created by Anton Cherkasov on 10.03.2026.
//

import SwiftUI

#if canImport(AppKit)

import AppKit

extension Color {

	static var tertiary: Color {
		Color(nsColor: .tertiaryLabelColor)
	}
}
#elseif canImport(UIKit)

import UIKit

extension Color {

	static var tertiary: Color {
		Color(uiColor: .tertiaryLabel)
	}
}
#endif
