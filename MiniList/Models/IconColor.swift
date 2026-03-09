//
//  IconColor.swift
//  MiniList
//
//  Created by Anton Cherkasov on 10.03.2026.
//

import SwiftUI

enum IconColor: Int, CaseIterable, Identifiable {
	case primary
	case secondary
	case tertiary
	case red
	case orange
	case yellow
	case green
	case mint
	case teal
	case cyan
	case blue
	case indigo
	case purple
	case pink
	case brown
}
extension IconColor {

	var id: Int {
		rawValue
	}

	var title: String {
		switch self {
		case .primary: "Primary"
		case .secondary: "Secondary"
		case .tertiary: "Tertiary"
		case .red: "Red"
		case .orange: "Orange"
		case .yellow: "Yellow"
		case .green: "Green"
		case .mint: "Mint"
		case .teal: "Teal"
		case .cyan: "Cyan"
		case .blue: "Blue"
		case .indigo: "Indigo"
		case .purple: "Purple"
		case .pink: "Pink"
		case .brown: "Brown"
		}
	}

	var color: Color {
		switch self {
		case .primary: .primary
		case .secondary: .secondary
		case .tertiary: .tertiary
		case .red: .red
		case .orange: .orange
		case .yellow: .yellow
		case .green: .green
		case .mint: .mint
		case .teal: .teal
		case .cyan: .cyan
		case .blue: .blue
		case .indigo: .indigo
		case .purple: .purple
		case .pink: .pink
		case .brown: .brown
		}
	}
}

// MARK: - Codable
extension IconColor: Codable { }

// MARK: - Hashable
extension IconColor: Hashable { }

