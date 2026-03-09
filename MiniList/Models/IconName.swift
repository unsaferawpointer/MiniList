//
//  IconName.swift
//  MiniList
//
//  Created by Anton Cherkasov on 09.03.2026.
//

enum IconName: Int {
	case none
	case star
	case heart
	case bolt
	case flag
	case bookmark
	case tag
	case calendar
	case clock
	case bell
	case doc
	case paperclip
	case link
	case pin
	case location
	case person
	case cart
	case gift
}

// MARK: - CaseIterable
extension IconName: CaseIterable { }

// MARK: - Identifiable
extension IconName: Identifiable {

	var id: Int {
		rawValue
	}
}

// MARK: - Codable
extension IconName: Codable { }

// MARK: - Hashable
extension IconName: Hashable { }
