//
//  ListContent.swift
//  MiniList
//
//  Created by Anton Cherkasov on 01.03.2026.
//

import Foundation

struct ListContent {

	var lines: [Line]

	init(lines: [Line] = []) {
		self.lines = lines
	}
}

// MARK: - Codable
extension ListContent: Codable { }
