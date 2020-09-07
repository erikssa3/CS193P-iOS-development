//
//  Array+Only.swift
//  Memorizer
//
//  Created by Anton Eriksson on 7.9.2020.
//  Copyright © 2020 Anton Eriksson. All rights reserved.
//

import Foundation


extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
