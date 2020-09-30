//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Anton Eriksson on 27.9.2020.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    
    private static let untitled = "EmojiArtDocument.Untitled"

    static let palette: String = "⭐️🌨🍏🥐🦑🤬"
    
    private var emojiArt: EmojiArt = EmojiArt() {
        willSet {
            objectWillChange.send()
        }
        didSet {
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    
    }
    
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?
    
    var emojies: [EmojiArt.Emoji] { emojiArt.emojies }
    
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojies.firstIndex(matching: emoji) {
            emojiArt.emojies[index].x += Int(offset.width)
            emojiArt.emojies[index].y += Int(offset.height)

        }
    }
    
    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojies.firstIndex(matching: emoji) {
            let newSize = Int((CGFloat(emojiArt.emojies[index].size) * scale).rounded(.toNearestOrEven))
            emojiArt.emojies[index].size += newSize
        }
    }
    
    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }
    
    private func fetchBackgroundImageData() {
        backgroundImage = nil
        if let url = emojiArt.backgroundURL {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {
                            self.backgroundImage = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}
