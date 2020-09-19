//
//  ContentView.swift
//  SetCardGame
//
//  Created by Anton Eriksson on 9.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI

struct SetGameView: View {
    @ObservedObject var game: SetCardGame
    var body: some View {
        return Grid(game.cards) { card in
            Card(card: card).onTapGesture {
                self.game.choose(card: card)
            }
        }.padding()
    }
}



struct Card: View {
    var card: SetGame.Card
    
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
                ForEach(0..<card.shapeCount) { _ in
                    self.cardShape(card: self.card)
                        .frame(width: size.width * self.widthFactor, height: size.height * self.heightFactor)
                }
            }
            .padding(.vertical)
        }
        .padding(5)
        .aspectRatio(2/3, contentMode: .fit)
    }
    
    func borderColor(card: SetGame.Card) -> Color {
        switch card.status {
        case .partOfValidSet:
            return Color.green
        case .partOfInvalidSet:
            return Color.red
        default:
            return Color.black
        }
    }
    
    func cardShape(card: SetGame.Card) -> some View {
        switch card.shape {
        case .diamond: return self.drawDiamond(card: card)
        case .oval: return drawOval(card: card)
        default: return drawRectangle(card: card)
        }
    }
    
    func getColor(color: SetGameColor) -> Color {
        switch color {
        case .blue: return Color.blue
        case .green: return Color.green
        default: return Color.red
        }
    }
    
    func drawDiamond(card: SetGame.Card) -> AnyView {
        switch card.shading {
        case .solid:
            return AnyView(Diamond().fill(self.getColor(color: card.color)))
        case .opaque:
            return AnyView(Diamond().fill(self.getColor(color: card.color)).opacity(0.4))
        default:
            return AnyView(Diamond().stroke(self.getColor(color: card.color)))
        }
    }
    
    func drawOval(card: SetGame.Card) -> AnyView {
        switch card.shading {
        case .solid:
            return AnyView(RoundedRectangle(cornerRadius: 30.0).fill(self.getColor(color: card.color)))
        case .opaque:
            return AnyView(RoundedRectangle(cornerRadius: 30.0).fill(self.getColor(color: card.color)).opacity(0.4))
        default:
            return AnyView(RoundedRectangle(cornerRadius: 30.0).stroke(self.getColor(color: card.color)))
        }
    }
    
    func drawRectangle(card: SetGame.Card) -> AnyView {
        switch card.shading {
        case .solid:
            return AnyView(RoundedRectangle(cornerRadius: 2).fill(self.getColor(color: card.color)))
        case .opaque:
            return AnyView(RoundedRectangle(cornerRadius: 2).fill(self.getColor(color: card.color)).opacity(0.4))
        default:
            return AnyView(RoundedRectangle(cornerRadius: 2).stroke(self.getColor(color: card.color)))
        }
    }
    
    let widthFactor: CGFloat = 0.7
    let heightFactor: CGFloat = 0.2
    let cornerRadius: CGFloat = 12.0
    let edgeLineWidth: CGFloat = 3
}

struct CardShapeView {
    var card: SetGame.Card
    
}


struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        let verticalScaleFactor: CGFloat = 0.9
        let diamondHeight = rect.maxY * verticalScaleFactor
        let topMiddle = CGPoint(x: rect.midX, y: rect.maxY - diamondHeight)
        let middleLeft = CGPoint(x: 0, y: rect.midY)
        let bottomMiddle = CGPoint(x: rect.midX, y: diamondHeight)
        let middleRight = CGPoint(x: rect.maxX, y: rect.midY)
        
        var p = Path()
        p.move(to: topMiddle)
        p.addLine(to: middleLeft)
        p.addLine(to: bottomMiddle)
        p.addLine(to: middleRight)
        p.addLine(to: topMiddle)
        return p
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetCardGame())
    }
}
