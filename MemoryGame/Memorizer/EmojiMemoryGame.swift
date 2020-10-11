//
//  EmojiMemoryGame.swift
//  Memorizer
//
//  Created by Anton Eriksson on 6.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI

let orange = UIColor.RGB(red: 255/255, green: 69/255, blue: 0/255, alpha: 1)
let green = UIColor.RGB(red: 50/255, green: 205/255, blue: 50/255, alpha: 1)
let red = UIColor.RGB(red: 139/255, green: 0/255, blue: 0/255, alpha: 1)
let gray = UIColor.RGB(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
let yellow = UIColor.RGB(red: 255/255, green: 255/255, blue: 0/255, alpha: 1)
let magneta = UIColor.RGB(red: 139/255, green: 0/255, blue: 139/255, alpha: 1)

struct Theme: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var emojies: Array<String>
    var color: UIColor.RGB
    var pairAmount: Int
}

class EmojiMemoryGame: ObservableObject {
    private var theme: Theme
    @Published private var model: MemoryGame<String>

    private static var themes = [
        Theme(name: "Halloween", emojies: ["👻", "🎃", "🕷", "🔦", "🧙🏿‍♂️" ], color: orange, pairAmount: 2),
        Theme(name: "Animals", emojies: ["🐥", "🐬", "🦑", "🐢"], color: green, pairAmount: 2),
        Theme(name: "Food", emojies: ["🍣", "🌭", "🥐", "🥓"], color: red, pairAmount: 3),
        Theme(name: "Times", emojies: ["🕐", "🕑", "🕖", "🕗", "🕡", "🕧"], color: gray, pairAmount: 6),
        Theme(name: "Weather", emojies: ["☀️", "🌥", "⛈", "🌨"], color: yellow, pairAmount: 4),
        Theme(name: "Faces", emojies: ["🥳", "😂", "😫", "😎", "😝", "🥶"], color: magneta, pairAmount: 2),
        ]
    
    init(theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let jsonData = try? JSONEncoder().encode(theme)
        print(String(data: jsonData!, encoding: .utf8) ?? "no json found")
        return MemoryGame<String>(numberOfPairsOfCards: theme.pairAmount, color: theme.color, name: theme.name) { pairIndex in
            return theme.emojies[pairIndex]
        }
    }
    
    var cards: Array<MemoryGame<String>.Card>{
        model.cards
    }
    
    var themeColor: UIColor.RGB {
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
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    

}

