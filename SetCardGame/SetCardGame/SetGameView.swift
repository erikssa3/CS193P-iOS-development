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
        return Grid(game.cards) { (card: SetGame<SetShape>.Card) in
            Card(card: card).onTapGesture {
                self.game.choose(card: card)
            }
        }.padding()
    }
}



struct Card: View {
    var card: SetGame<SetShape>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius).fill(card.status == CardStatus.selected ? Color.gray : Color.white)
            RoundedRectangle(cornerRadius: cornerRadius).stroke(borderColor(card: card), lineWidth: edgeLineWidth)
            VStack {
                ForEach(0..<card.contentCount) { _ in
                    if self.card.shading == .solid || self.card.shading == .opaque {
                        self.card.content
                            .fill(self.getColor(color: self.card.color))
                            .opacity(self.card.shading == .opaque ? 0.4 : 1)
                    } else {
                        self.card.content
                            .stroke(self.getColor(color: self.card.color))
                    }
                }
                .frame(width: size.width * self.widthFactor, height: size.height * self.heightFactor)
            }
            .padding(.vertical)
        }
        .padding(5)
        .aspectRatio(2/3, contentMode: .fit)
    }
    
    func borderColor(card: SetGame<SetShape>.Card) -> Color {
        switch card.status {
        case .partOfValidSet:
            return Color.green
        case .partOfInvalidSet:
            return Color.red
        default:
            return Color.black
        }
    }
    
    func getColor(color: SetGameColor) -> Color {
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

struct CardShapeView {
    var card: SetGame<SetShape>.Card
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: ShapeSetGame())
    }
}
