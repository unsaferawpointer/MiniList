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
		}
	}
}
