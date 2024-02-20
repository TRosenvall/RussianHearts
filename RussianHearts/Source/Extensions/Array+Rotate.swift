//
//  Array+Rotate.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 12/21/23.
//

import Foundation

extension Array {
    func rotate(by amount: Int = 1) -> [Element] {
        guard self.count > 0
        else { return self }

        if amount <= 0 {
            return self
        } else {
            var array = self
            let element = array.remove(at: 0)
            array.append(element)
            return array.rotate(by: amount - 1)
        }
    }
}
