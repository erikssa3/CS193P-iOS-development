//
//  EmojiMemoryGame.swift
//  Memorizer
//
//  Created by Anton Eriksson on 6.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI


class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()

    static var themes = [
        MemoryGame<String>.Theme(name: "Halloween", emojies: ["👻", "🎃", "🕷", "🔦", "🧙🏿‍♂️" ], color: Color.orange),
        MemoryGame<String>.Theme(name: "Animals", emojies: ["🐥", "🐬", "🦑", "🐢"], color: Color.green, pairAmount: 2),
        MemoryGame<String>.Theme(name: "Food", emojies: ["🍣", "🌭", "🥐", "🥓"], color: Color.red, pairAmount: 3),
        MemoryGame<String>.Theme(name: "Times", emojies: ["🕐", "🕑", "🕖", "🕗", "🕡", "🕧"], color: Color.gray, pairAmount: 6),
        MemoryGame<String>.Theme(name: "Weather", emojies: ["☀️", "🌥", "⛈", "🌨"], color: Color.yellow, pairAmount: 4),
        MemoryGame<String>.Theme(name: "Faces", emojies: ["🥳", "😂", "😫", "😎", "😝", "🥶"], color: Color.yellow),
        ]
    
    static func createMemoryGame() -> MemoryGame<String> {
        let theme = themes.randomElement()!
        let pairAmount = theme.pairAmount ?? Int.random(in: 2...theme.emojies.count)
        return MemoryGame<String>(numberOfPairsOfCards: pairAmount, color: theme.color, name: theme.name) { pairIndex in
            return theme.emojies[pairIndex]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    var themeColor: Color {
        model.themeColor
    }
    
    var themeName: String {
        model.themeName
    }
    
    var score: Int {
        model.score
    }
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    func startGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
    

}

