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
        model.cardsBy(statuses: [.onScreen, .partOfInvalidSet, .partOfValidSet, .selected])
    }
    
    
    func choose(card: SetGame.Card) {
        model.choose(card: card)
    }
}
