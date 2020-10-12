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
    @State private var editMode: EditMode = .inactive

    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme)).navigationBarTitle(theme.name)) {
                        ThemeRow(theme: theme, isEditing: editMode.isEditing, store: store)
                    }
                }.onDelete { indexSet in
                    print(indexSet)
                }
            }
            .navigationBarTitle("Memorize")
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, $editMode)
        }
    
    }
}

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
                        onRename(newName: themeName)
                    }
                })
                Section(header: Text("Add Emoji")) {
                    HStack {
                        TextField("Emoji", text: $emojiesToAdd)
                        Button("Add") {
                            onAddEmojis(newEmojis: emojiesToAdd)
                            chosenPalette += emojiesToAdd.map( {String($0)} )
                            emojiesToAdd = ""
                        }
                    }
                }
                Section(header: EmojiSectionHeader()) {
                    HStack {
                        ForEach(chosenPalette, id: \.self) { emoji in
                            Text(emoji)
                                .font(.title)
                                .onTapGesture {
                                    if (chosenPalette.count > 2) {
                                        onRemoveEmoji(emoji: emoji)
                                        chosenPalette = chosenPalette.filter({ $0 != emoji })
                                    }
                                }
                        }
                    }
                }
                Section(header: Text("Card Count")) {
                    HStack {
                        Stepper(value: $pairCount, in: 2...max(chosenPalette.count,2), step: 1, onEditingChanged: { began in
                            if !began {
                                onStepperAction()
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
    
    func onAddEmojis(newEmojis: String) {
        let index = store.themes.firstIndex(matching: theme)!
        let newEmojisArray: [String] = newEmojis.map( {String($0)} )
        store.themes[index].emojies = store.themes[index].emojies + newEmojisArray
    }
    
    func onRemoveEmoji(emoji: String) {
        let index = store.themes.firstIndex(matching: theme)!
        store.themes[index].emojies = store.themes[index].emojies.filter({ $0 != emoji })
    }
    
    func onRename(newName: String) {
        let index = store.themes.firstIndex(matching: theme)!
        store.themes[index].name = newName
    }
    
    func onStepperAction() {
        let index = store.themes.firstIndex(matching: theme)!
        store.themes[index].pairAmount = pairCount
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



struct ThemeRow: View {
    var theme: Theme
    var emojis: String
    var isEditing: Bool
    @State var showThemeEditor: Bool = false
    @ObservedObject var store: EmojiMemoryThemeStore
    
    init(theme: Theme, isEditing: Bool, store: EmojiMemoryThemeStore) {
        let emojisPrefix = theme.pairAmount == nil ? "All of " : "\(theme.pairAmount) pairs from "
        self.theme = theme
        self.emojis = emojisPrefix + theme.emojies.joined(separator: "")
        self.isEditing = isEditing
        self.store = store
    }
    
   
    var body: some View {
        HStack{
            if isEditing {
                Image(systemName: "pencil.circle.fill")
                    .font(.title)
                    .foregroundColor(Color(theme.color))
                    .onTapGesture {
                        showThemeEditor = true
                    }
                    .popover(isPresented: $showThemeEditor) {
                        ThemeEditor(theme: theme, isShowing: $showThemeEditor)
                            .environmentObject(store)
                    }
            }
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

