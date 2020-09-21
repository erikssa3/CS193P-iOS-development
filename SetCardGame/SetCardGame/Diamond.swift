//
//  Diamond.swift
//  SetCardGame
//
//  Created by Anton Eriksson on 19.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import SwiftUI

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
