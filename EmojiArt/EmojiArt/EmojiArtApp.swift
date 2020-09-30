//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Anton Eriksson on 27.9.2020.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: EmojiArtDocument())
        }
    }
}
