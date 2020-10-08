//
//  EmojiMemoryGameChooser.swift
//  Memorizer
//
//  Created by Anton Eriksson on 8.10.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI

struct EmojiMemoryThemeChooser: View {
    @EnvironmentObject var store: EmojiMemoryThemeStore
    
    var body: some View {
        NavigationView {
            List {
                
            }
        }
    }
}

struct EmojiMemoryGameChooser_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryThemeChooser()
    }
}
