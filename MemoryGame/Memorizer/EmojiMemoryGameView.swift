//
//  EmojiMemoryGameView.swift
//  Memorizer
//
//  Created by Anton Eriksson on 6.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear) {
                        self.viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .foregroundColor(Color(viewModel.themeColor))
            HStack {
                Button("New game") {
                    withAnimation(.easeInOut) {
                        self.viewModel.startGame()
                    }
                }
                Text("Score: \(viewModel.score)")
            }
        }
    }
}



struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    private func body(for size: CGSize) -> some View {
        ZStack {
            Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.init(degrees: 110-90))
                .padding(5).opacity(0.4)
            Text(card.content)
                .font(Font.system(size: fontSize(for: size)))
                .rotationEffect(Angle.degrees((card.isMatched ? 360 : 0)))
                .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
        }
        .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched)
        .rotation3DEffect(Angle.degrees(card.isFaceUp ? 0 : 180), axis: (0, 1, 0))
        .aspectRatio(2/3, contentMode: .fit)
    }
}

// MARK: - Drawing Constants
private let fontScaleFactor: CGFloat = 0.5
private func fontSize(for size: CGSize) -> CGFloat {
    min(size.width, size.height) * fontScaleFactor
}



