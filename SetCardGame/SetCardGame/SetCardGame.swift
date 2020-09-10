//
//  SetCardGame.swift
//  SetCardGame
//
//  Created by Anton Eriksson on 9.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import Foundation


class SetCardGame: ObservableObject {
    
    @Published private var model = SetGame()
    
    var cards: [SetGame.Card] {
        Array(model.cards.shuffled().prefix(12))
    }
}
