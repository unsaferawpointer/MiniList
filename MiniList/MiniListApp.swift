//
//  MiniListApp.swift
//  MiniList
//
//  Created by Anton Cherkasov on 28.02.2026.
//

import SwiftUI

@main
struct MiniListApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: ListDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
