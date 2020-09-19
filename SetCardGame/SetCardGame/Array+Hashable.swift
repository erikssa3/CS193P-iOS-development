//
//  Array+Hashable.swift
//  SetCardGame
//
//  Created by Anton Eriksson on 19.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    func isAllSameOrDistinct() -> Bool {
        let isAllSame = Set(self).count == 1
        let isAllDifferent = Set(self).count == self.count
        
        return isAllSame || isAllDifferent
    }
}
