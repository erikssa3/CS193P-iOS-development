//
//  EmojiMemoryGame.swift
//  Memorizer
//
//  Created by Anton Eriksson on 6.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI


class EmojiMemoryGame {
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    static func createMemoryGame() -> MemoryGame<String> {
        let pairAmount = Int.random(in: 2...5)
        let emojis = ["👻", "🎃", "🕷", "🔦", "🧙🏿‍♂️" ].prefix(pairAmount)
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
}

