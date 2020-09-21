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


let shapeCount = 3


class ShapeSetGame: ObservableObject {
    
    @Published private var model: SetGame<SetShape> = ShapeSetGame.createGame()
    
    
    static func createGame() -> SetGame<SetShape> {
        let cardShapes = SetGameShape.allCases.map{SetShape(shapeType: $0)}
        return SetGame(cardContents: cardShapes)
    }
    

    var cards: [SetGame<SetShape>.Card] {
        model.cardsBy(statuses: [.onScreen, .partOfInvalidSet, .partOfValidSet, .selected])
    }
    
    
    func choose(card: SetGame<SetShape>.Card) {
        model.choose(card: card)
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
