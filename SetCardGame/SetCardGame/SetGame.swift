//
//  SetGame.swift
//  SetCardGame
//
//  Created by Anton Eriksson on 9.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import Foundation
import SwiftUI

enum CardStatus {
    case inPack
    case onScreen
    case partOfValidSet
    case partOfInvalidSet
    case selected
    case removed
}


struct SetGame<CardContent> where CardContent: Hashable {
    private (set) var cards: [Card] = []
    private var emptyCardPositions: [Int] = Array(0...11)

    let initialCardCount = 12

    func cardsBy(status: CardStatus) -> [Card]   {
        cards.filter{ card in card.status == status }
    }
    
    func cardsBy(statuses: [CardStatus]) -> [Card]   {
        cards.filter{ card in statuses.contains(card.status) }
    }
    
    var hasSetSelected: Bool {
        cardsBy(statuses: [.partOfInvalidSet, .partOfValidSet]).count == 3
    }
    
    var hasValidSetSelected: Bool {
        cardsBy(status: .partOfValidSet).count == 3
}

    init(cardContents: [CardContent], contentCount: Int)  {
        var cardId = 0
        for content in cardContents {
            for count in 1...contentCount {
                for color in SetGameColor.allCases {
                    for shading in SetGameShading.allCases {
                        let card = Card(id: cardId, contentCount: count, content: content, color: color, shading: shading)
                        cards.append(card)
                        cardId += 1
                    }
                }
            }
        }
        cards.shuffle()
        dealCards(amount: initialCardCount)
    }
    
    
    private mutating func dealCards(amount: Int) {
        let newCards = cardsBy(status: .inPack).prefix(amount)
        for card in newCards {
            let cardIndex = cards.firstIndex(matching: card)!
            cards[cardIndex].status = .onScreen
            if emptyCardPositions.isEmpty {
                cards[cardIndex].position = cardsBy(status: .onScreen).count
            } else {
                cards[cardIndex].position = emptyCardPositions.removeFirst()
            }
        }
    }
    
    
    
    private mutating func switchCardsStatus(oldStatus: CardStatus, newStatus: CardStatus) {
        for card in cardsBy(status: oldStatus) {
            let cardIndex = cards.firstIndex(matching: card)!
            self.cards[cardIndex].status = newStatus
            if newStatus == .removed {
                emptyCardPositions.append(self.cards[cardIndex].position!)
            }
        }
    }
    
    
    func isSelectedSetValid() -> Bool {
        guard cardsBy(statuses: [.selected]).count == 3 else {
            return false
        }
        
        let cardColors = cardsBy(status: .selected).map{ card in card.color }
        let cardShapes = cardsBy(status: .selected).map{ card in card.content }
        let cardShadings = cardsBy(status: .selected).map{ card in card.shading }
        let cardShapeCounts = cardsBy(status: .selected).map{ card in card.contentCount }
        
        return cardColors.isAllSameOrDistinct()
            && cardShapes.isAllSameOrDistinct()
            && cardShadings.isAllSameOrDistinct()
            && cardShapeCounts.isAllSameOrDistinct()
    }

    mutating func choose(card: Card) {
        let chosenIndex = cards.firstIndex(matching: card)!
        if hasSetSelected {
            if hasValidSetSelected {
                switchCardsStatus(oldStatus: .partOfValidSet,newStatus: .removed)
                dealCards(amount: 3)
                if cards[chosenIndex].status == .onScreen {
                    cards[chosenIndex].status = .selected
                }
            } else {
                switchCardsStatus(oldStatus: .partOfInvalidSet, newStatus: .onScreen)
                cards[chosenIndex].status = .selected
            }
        } else {
            if cardsBy(status: .selected).count < 3 {
                cards[chosenIndex].status = .selected
            }
            if cardsBy(status: .selected).count == 3 {
                switchCardsStatus(oldStatus: .selected, newStatus: isSelectedSetValid() ? CardStatus.partOfValidSet : CardStatus.partOfInvalidSet)
            }
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        var position: Int?
        var status: CardStatus = .inPack
        var contentCount: Int
        var content: CardContent
        var color: SetGameColor
        var shading: SetGameShading
    }
}
