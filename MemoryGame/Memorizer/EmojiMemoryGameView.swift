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
            HStack(alignment: .lastTextBaseline) {
                Text(viewModel.themeName)
                    .font(Font.title)
                Text("Score: \(viewModel.score)")
            }
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
                .padding(5)
            }
            .padding()
            .foregroundColor(viewModel.themeColor)
            Button("New game") {
                self.viewModel.startGame()
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
            }
            .cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched)
            .aspectRatio(2/3, contentMode: .fit)
    }
   
    // MARK: - Drawing Constants
    private let fontScaleFactor: CGFloat = 0.5
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * fontScaleFactor
    }
}









struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
