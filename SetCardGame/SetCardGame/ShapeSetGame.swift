//
//  SetCardGame.swift
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
    case opaque
    case open
}

typealias ShapeSetGameCard = SetGame<SetShape>.Card

class ShapeSetGame: ObservableObject {
    
    @Published private var model: SetGame<SetShape> = ShapeSetGame.initGame()
    
    static func initGame() -> SetGame<SetShape> {
        let cardShapes = SetGameShape.allCases.map{ SetShape(shapeType: $0) }
        return SetGame(cardContents: cardShapes, contentCount: 3)
    }

    var activeCards: [ShapeSetGameCard] {
        model.cardsBy(statuses: [.onScreen, .partOfInvalidSet, .partOfValidSet, .selected]).sorted{ $0.position! < $1.position! }
    }
    
    var hasNoCardsInDeck: Bool {
        model.cardsBy(status: .inPack).isEmpty
    }
    
    var hasValidSetSelected: Bool {
        model.hasValidSetSelected
    }
    
    func choose(card: ShapeSetGameCard) {
        model.choose(card: card)
    }
    
    func dealMoreCards() {
        if hasValidSetSelected {
            model.replaceCardsInValidSet()
        } else {
            model.dealCards(amount: 3)
        }
    }
    
    func restartGame() {
        model = ShapeSetGame.initGame()
    }
    
    
}


struct SetShape: Shape, Hashable {
    var shapeType: SetGameShape
    
    func path(in rect: CGRect) -> Path {
        switch shapeType {
        case .diamond: return Diamond().path(in: rect)
        case .oval: return RoundedRectangle(cornerRadius: ovalRadius).path(in: rect)
        default: return RoundedRectangle(cornerRadius: rectangelRadius).path(in: rect)
        }
    }
    
    let ovalRadius: CGFloat = 30.0
    let rectangelRadius: CGFloat = 2.0
}
