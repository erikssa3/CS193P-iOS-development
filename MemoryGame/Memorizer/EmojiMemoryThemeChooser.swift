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
    @State private var showThemeEditor: Bool = false

    var body: some View {
        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme)).navigationBarTitle(theme.name)) {
                        ThemeRow(theme: theme, isEditing: editMode.isEditing, store: store, showThemeEditor: $showThemeEditor)
                    }
                }.onDelete { indexSet in
                    print(indexSet)
                }
            }
            .navigationBarTitle("Memorize")
            .navigationBarItems(leading: Button(action: {
                let newTheme = Theme(name: "", emojies: ["🥰", "😘"], color: blue, pairAmount: 2)
                store.addTheme(theme: newTheme)
                showThemeEditor = true
            }, label: {
                Image(systemName: "plus").imageScale(.large)
                    .popover(isPresented: $showThemeEditor) {
                        ThemeEditor(theme: store.themes.last!, isShowing: $showThemeEditor)
                            .environmentObject(store)
                    }
            }),
            trailing: EditButton())
            .environment(\.editMode, $editMode)
        }
    }
}

struct ThemeRow: View {
    var theme: Theme
    var emojis: String
    var isEditing: Bool
    @Binding var showThemeEditor: Bool
    @ObservedObject var store: EmojiMemoryThemeStore
    
    init(theme: Theme, isEditing: Bool, store: EmojiMemoryThemeStore, showThemeEditor: Binding<Bool>) {
        let emojisPrefix = theme.pairAmount == theme.emojies.count ? "All of " : "\(theme.pairAmount) pairs from "
        self.theme = theme
        self.emojis = emojisPrefix + theme.emojies.joined(separator: "")
        self.isEditing = isEditing
        self.store = store
        self._showThemeEditor = showThemeEditor
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

