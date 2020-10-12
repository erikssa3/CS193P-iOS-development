//
//  ThemeEditor.swift
//  Memorizer
//
//  Created by Anton Eriksson on 12.10.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI

struct ThemeEditor: View {
    var theme: Theme
    @EnvironmentObject var store: EmojiMemoryThemeStore
    @Binding var isShowing: Bool
    @State var emojiesToAdd = ""
    @State var chosenPalette: [String] = []
    @State var themeName = ""
    @State var pairCount = 0
    
    var body: some View {
        VStack {
            ZStack {
                Text("Theme editor").font(.headline).padding()
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }, label: { Text("Done") }).padding()
                }
            }
            Form {
                TextField("Theme Name", text: $themeName, onEditingChanged: { began in
                    if !began {
                        store.rename(theme: theme, newName: themeName)
                    }
                })
                Section(header: Text("Add Emoji")) {
                    HStack {
                        TextField("Emoji", text: $emojiesToAdd)
                        Button("Add") {
                            store.addEmojis(theme: theme, newEmojis: emojiesToAdd)
                            chosenPalette += emojiesToAdd.map( {String($0)} )
                            emojiesToAdd = ""
                        }
                    }
                }
                Section(header: EmojiSectionHeader()) {
                    ChosenEmojies(chosenPalette: $chosenPalette, theme: theme)
                        .environmentObject(store)
                }
                Section(header: Text("Card Count")) {
                    HStack {
                        Stepper(value: $pairCount, in: 2...max(chosenPalette.count,2), step: 1, onEditingChanged: { began in
                            if !began {
                                store.setPairAmount(theme: theme, pairCount: pairCount)
                            }
                        }) { Text("\(pairCount) Pairs") }
                    }
                }
            }
        }.onAppear(perform: {
            themeName = theme.name
            chosenPalette = theme.emojies
            pairCount = theme.pairAmount
        })
    }
}

struct ChosenEmojies: View {
    @Binding var chosenPalette: [String]
    @EnvironmentObject var store: EmojiMemoryThemeStore
    var theme: Theme
    
    var body: some View {
        if #available(iOS 14.0, *) {
            LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]) {
                ForEach(chosenPalette, id: \.self) { emoji in
                    Text(emoji)
                        .font(.title)
                        .onTapGesture {
                            if (chosenPalette.count > 2) {
                                store.removeEmoji(theme: theme, emoji: emoji)
                                chosenPalette = chosenPalette.filter({ $0 != emoji })
                            }
                        }
                }
            }
        } else {
            HStack{
                ForEach(chosenPalette, id: \.self) { emoji in
                    Text(emoji)
                        .font(.title)
                        .onTapGesture {
                            if (chosenPalette.count > 2) {
                                store.removeEmoji(theme: theme, emoji: emoji)
                                chosenPalette = chosenPalette.filter({ $0 != emoji })
                            }
                        }
                }
            }
        }
    }
}

struct EmojiSectionHeader: View {
    var body: some View {
        HStack() {
            Text("Emojis")
            Spacer()
            Text("tap emoji to exclude")
                .font(.caption)
        }
    }
}
