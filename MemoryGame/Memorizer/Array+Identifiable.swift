//
//  Array+Identifiable.swift
//  Memorizer
//
//  Created by Anton Eriksson on 7.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
    
}
