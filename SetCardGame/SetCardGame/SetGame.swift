//
//  SetGame.swift
//  SetCardGame
//
//  Created by Anton Eriksson on 9.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import Foundation
import SwiftUI

enum SetGameShape: CaseIterable {
    case diamond
    case oval
    case rectangle
}

enum SetGameColor: CaseIterable {
    case green
    case red
    case blue
}

enum SetGameShading: CaseIterable {
    case solid
    case striped
    case open
}

let shapeCount = 3


struct SetGame {
    private(set) var cards: [Card] = []
    
    
    init() {
        var cardId = 0
        for shape in SetGameShape.allCases {
            for count in 1...shapeCount {
                for color in SetGameColor.allCases {
                    for shading in SetGameShading.allCases {
                        let card = Card(id: cardId, shapeCount: count, shape: shape, color: color, shading: shading)
                        cards.append(card)
                        cardId += 1
                }
            }
        }
        }
    }
    
    
    struct Card: Identifiable {
        var id: Int
        var isSelected: Bool = false
        var isShown: Bool = false
        var shapeCount: Int
        var shape: SetGameShape
        var color: SetGameColor
        var shading: SetGameShading
    }
}
