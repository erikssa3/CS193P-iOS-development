//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Anton Eriksson on 27.9.2020.
//

import Foundation

struct EmojiArt: Codable {
    var backgroundURL: URL?
    var emojies = [Emoji]()
    
    struct Emoji: Identifiable, Codable, Hashable {
        let id: Int
        let text: String
        var x: Int
        var y: Int
        var size: Int
        
        fileprivate init(id: Int, text: String, x: Int, y: Int, size: Int) {
            self.text = text
            self.x = x
            self.y = y
            self.size = size
            self.id = id
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data?) {
        if json != nil, let newEmojiArt = try? JSONDecoder().decode(EmojiArt.self, from: json!) {
            self = newEmojiArt
        } else {
            return nil
        }
    }
    
    init() {}
    
    private var uniqueEmojiId = 0

    mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
        uniqueEmojiId += 1
        emojies.append(Emoji(id: uniqueEmojiId, text: text, x: x, y: y, size: size))
    }
}
