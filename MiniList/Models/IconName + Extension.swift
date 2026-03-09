//
//  IconName + Extension.swift
//  MiniList
//
//  Created by Anton Cherkasov on 09.03.2026.
//

import SwiftUI

extension IconName {

	var image: Image {
		switch self {
		case .none:
			Image(.dot)
		case .star:
			Image(systemName: "star.fill")
		case .heart:
			Image(systemName: "heart.fill")
		case .bolt:
			Image(systemName: "bolt.fill")
		case .flag:
			Image(systemName: "flag.fill")
		case .bookmark:
			Image(systemName: "bookmark.fill")
		case .tag:
			Image(systemName: "tag.fill")
		case .calendar:
			Image(systemName: "calendar")
		case .clock:
			Image(systemName: "clock.fill")
		case .bell:
			Image(systemName: "bell.fill")
		case .doc:
			Image(systemName: "doc.fill")
		case .paperclip:
			Image(systemName: "paperclip")
		case .link:
			Image(systemName: "link")
		case .pin:
			Image(systemName: "pin.fill")
		case .location:
			Image(systemName: "location.fill")
		case .person:
			Image(systemName: "person.fill")
		case .cart:
			Image(systemName: "cart.fill")
		case .gift:
			Image(systemName: "gift.fill")
		}
	}

	var title: String {
		switch self {
		case .none:
			"Dot"
		case .star:
			"Star"
		case .heart:
			"Heart"
		case .bolt:
			"Bolt"
		case .flag:
			"Flag"
		case .bookmark:
			"Bookmark"
		case .tag:
			"Tag"
		case .calendar:
			"Calendar"
		case .clock:
			"Clock"
		case .bell:
			"Bell"
		case .doc:
			"Document"
		case .paperclip:
			"Paperclip"
		case .link:
			"Link"
		case .pin:
			"Pin"
		case .location:
			"Location"
		case .person:
			"Person"
		case .cart:
			"Cart"
		case .gift:
			"Gift"
		}
	}
}
