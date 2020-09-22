//
//  ContentView.swift
//  SetCardGame
//
//  Created by Anton Eriksson on 9.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: ShapeSetGame
    
    var body: some View {
        VStack {
            Grid(game.cards) { (card: SetGame<SetShape>.Card) in
                Card(card: card).onTapGesture {
                    if game.hasValidSetSelected {
                        withAnimation(.easeOut(duration: 0.8)) {
                            game.choose(card: card)
                        }
                    } else {
                        game.choose(card: card)
                    }
                }
            }
            .padding()
            HStack {
                Button("New Game"){
                    withAnimation(.easeOut(duration: 1)) {
                        game.restartGame()
                    }
                }
                .padding(.horizontal)
                Button("Deal three cards") {
                    withAnimation(.easeOut(duration: 0.8)) {
                        game.dealMoreCards()
                    }
                }
                .disabled(game.hasNoCardsInDeck)
                .padding(.horizontal)
            }
        }
    }
}



struct Card: View {
    var card: SetGame<SetShape>.Card
    
    var isFilled: Bool {
        card.shading == .solid || card.shading == .opaque
    }
    
    var cardBackgroundColor: Color {
        card.status == CardStatus.selected ? Color.gray : Color.white
    }
    
    var cardOpacity: Double {
        card.shading == .opaque ? 0.4 : 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }.transition(AnyTransition.offset(animationStartLocation()))
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius).fill(cardBackgroundColor)
            RoundedRectangle(cornerRadius: cornerRadius).stroke(resolveBorderColor(card: card), lineWidth: edgeLineWidth)
            VStack {
                ForEach(0..<card.contentCount) { _ in
                    if isFilled {
                        card.content
                            .fill(resolveColor(color: card.color))
                            .opacity(cardOpacity)
                    } else {
                        card.content
                            .stroke(resolveColor(color: card.color))
                    }
                }
                .frame(width: size.width * widthFactor, height: size.height * heightFactor)
            }
            .padding(.vertical)
        }
        .padding(5)
        .aspectRatio(2/3, contentMode: .fit)

    }
    
    func animationStartLocation() -> CGSize {
        let angle = Double.random(in: 0..<2*Double.pi)
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        return CGSize(width: Double(screenWidth + 100) * cos(angle),
                      height: Double(screenHeight + 100) * sin(angle))
        }
    
    func resolveBorderColor(card: SetGame<SetShape>.Card) -> Color {
        switch card.status {
        case .partOfValidSet:
            return Color.green
        case .partOfInvalidSet:
            return Color.red
        default:
            return Color.black
        }
    }
    
    func resolveColor(color: SetGameColor) -> Color {
        switch color {
        case .blue: return Color.blue
        case .green: return Color.green
        default: return Color.red
        }
    }
    
    let widthFactor: CGFloat = 0.7
    let heightFactor: CGFloat = 0.2
    let cornerRadius: CGFloat = 12.0
    let edgeLineWidth: CGFloat = 3
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: ShapeSetGame())
    }
}
