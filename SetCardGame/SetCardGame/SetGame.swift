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
    case opaque
    case open
}

enum CardStatus {
    case inPack
    case onScreen
    case partOfValidSet
    case partOfInvalidSet
    case selected
    case removed
}

let shapeCount = 3


struct SetGame {
    private (set) var cards: [Card] = []

    func cardsBy(status: CardStatus) -> [Card]   {
        return cards.filter{ card in card.status == status }
    }
    
    func cardsBy(statuses: [CardStatus]) -> [Card]   {
        return cards.filter{ card in statuses.contains(card.status) }
    }
    
    var hasSetSelected: Bool {
        return cardsBy(statuses: [.partOfInvalidSet, .partOfValidSet]).count == 3
    }
    
    var hasValidSetSelected: Bool {
        return cardsBy(status: .partOfValidSet).count == 3
    }

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
        cards.shuffle()
        dealCards(amount: 12)
    }
    
    
    private mutating func dealCards(amount: Int) {
        let newCards = (cardsBy(status: .inPack).prefix(amount))
        for card in newCards {
            let cardIndex = cards.firstIndex(matching: card)!
            cards[cardIndex].status = .onScreen
        }
    }
    
    
    
    private mutating func setCardsStatus(oldStatus: CardStatus, newStatus: CardStatus) {
        for card in cardsBy(status: oldStatus) {
            let cardIndex = cards.firstIndex(matching: card)!
            self.cards[cardIndex].status = newStatus
        }
    }
    
    
    func isSelectedSetValid() -> Bool {
        guard cardsBy(statuses: [.selected]).count == 3 else {
            return false
        }
        
        let cardColors = cardsBy(status: .selected).map{ card in card.color }
        let cardShapes = cardsBy(status: .selected).map{ card in card.shape }
        let cardShadings = cardsBy(status: .selected).map{ card in card.shading }
        let cardShapeCounts = cardsBy(status: .selected).map{ card in card.shapeCount }
        
        return cardColors.isAllSameOrDistinct()
            && cardShapes.isAllSameOrDistinct()
            && cardShadings.isAllSameOrDistinct()
            && cardShapeCounts.isAllSameOrDistinct()
    }

    mutating func choose(card: Card) {
        let chosenIndex = cards.firstIndex(matching: card)!
        if hasSetSelected {
            if hasValidSetSelected {
                setCardsStatus(oldStatus: .partOfValidSet,newStatus: .removed)
                dealCards(amount: 3)
                if cards[chosenIndex].status == .onScreen {
                    cards[chosenIndex].status = .selected
                }
            } else {
                setCardsStatus(oldStatus: .partOfInvalidSet, newStatus: .onScreen)
                cards[chosenIndex].status = .selected
            }
        } else {
            if cardsBy(status: .selected).count < 3 {
                cards[chosenIndex].status = .selected
            }
            if cardsBy(status: .selected).count == 3 {
                setCardsStatus(oldStatus: .selected, newStatus: isSelectedSetValid() ? CardStatus.partOfValidSet : CardStatus.partOfInvalidSet)
            }
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        var status: CardStatus = .inPack
        var isShown: Bool = false
        var shapeCount: Int
        var shape: SetGameShape
        var color: SetGameColor
        var shading: SetGameShading
    }
}
