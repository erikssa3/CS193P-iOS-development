//
//  File.swift
//  Memorizer
//
//  Created by Anton Eriksson on 8.10.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import Foundation


class EmojiMemoryThemeStore: ObservableObject {
    
    @Published var themes: [Theme] = [
        Theme(name: "Halloween", emojies: ["👻", "🎃", "🕷", "🔦", "🧙🏿‍♂️" ], color: orange),
        Theme(name: "Times", emojies: ["🕐", "🕑", "🕖", "🕗", "🕡", "🕧"], color: gray, pairAmount: 6),
        Theme(name: "Weather", emojies: ["☀️", "🌥", "⛈", "🌨", "☀️", "🌥", "⛈", "🌨", "☀️", "🌥", "⛈", "🌨", "☀️", "🌥", "⛈", "🌨"], color: yellow, pairAmount: 4),
    ]
}
