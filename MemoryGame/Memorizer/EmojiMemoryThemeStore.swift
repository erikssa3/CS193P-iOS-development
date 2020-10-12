//
//  File.swift
//  Memorizer
//
//  Created by Anton Eriksson on 8.10.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import Foundation


class EmojiMemoryThemeStore: ObservableObject {
    
    static let defaultThemes: [Theme] = [
        Theme(name: "Halloween", emojies: ["👻", "🎃", "🕷", "🔦", "🧙🏿‍♂️" ], color: orange, pairAmount: 2),
        Theme(name: "Times", emojies: ["🕐", "🕑", "🕖", "🕗", "🕡", "🕧"], color: gray, pairAmount: 6),
        Theme(name: "Spooky Weather", emojies: ["☀️", "🌥", "⛈", "🌨", "👻", "🎃", "🕷", "🥳", "😂", "😫", "😎", "😝", "🥶"], color: yellow, pairAmount: 4),
    ]
    
    @Published var themes: [Theme] = EmojiMemoryThemeStore.defaultThemes
    
    func addEmojis(theme: Theme, newEmojis: String) {
        let index = themes.firstIndex(matching: theme)!
        let newEmojisArray: [String] = newEmojis.map( {String($0)} )
        themes[index].emojies = themes[index].emojies + newEmojisArray
    }
    
    func removeEmoji(theme: Theme, emoji: String) {
        let index = themes.firstIndex(matching: theme)!
        themes[index].emojies = themes[index].emojies.filter({ $0 != emoji })
    }
    
    func rename(theme: Theme, newName: String) {
        let index = themes.firstIndex(matching: theme)!
        themes[index].name = newName
    }
    
    func setPairAmount(theme: Theme, pairCount: Int) {
        let index = themes.firstIndex(matching: theme)!
        themes[index].pairAmount = pairCount
    }
    
    func add(theme: Theme) {
        themes.append(theme)
    }
    
    func removeTheme(index: Int) {
        themes.remove(at: index)
    }
}
