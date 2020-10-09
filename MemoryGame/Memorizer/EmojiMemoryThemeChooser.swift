//
//  EmojiMemoryGameChooser.swift
//  Memorizer
//
//  Created by Anton Eriksson on 8.10.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI

struct EmojiMemoryThemeChooser: View {
    @ObservedObject var store: EmojiMemoryThemeStore
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme)).navigationBarTitle(theme.name)) {
                        ThemeRow(theme: theme)
                    }
                }
            }
            .navigationBarTitle("Memorize")
        }
    
    }
}



struct ThemeRow: View {
    var theme: Theme
    var emojis: String
    
    init(theme: Theme) {
        let emojisPrefix = theme.pairAmount == nil ? "All of " : "\(theme.pairAmount!) pairs from "
        self.theme = theme
        self.emojis = emojisPrefix + theme.emojies.joined(separator: "")
    }
    
   
    var body: some View {
        HStack{
            Image(systemName: "pencil.circle.fill")
                .font(.largeTitle)
                .foregroundColor(Color(theme.color))
            VStack(alignment: .leading) {
                Text(theme.name)
                    .font(.title)
                    .foregroundColor(Color(theme.color))
                Text(emojis)
                    .truncationMode(/*@START_MENU_TOKEN@*/.tail/*@END_MENU_TOKEN@*/)
                    .lineLimit(1)
            }
        }
    }
}

struct ThemeRow_Previews: PreviewProvider {
    static var previews: some View {
        ThemeRow(theme: Theme(name: "Halloween", emojies: ["👻", "🎃", "🕷", "🔦", "🧙🏿‍♂️" ], color: orange))
    }
}
