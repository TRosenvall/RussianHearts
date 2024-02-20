//
//  Array+RemoveAt.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 12/24/23.
//

import Foundation

extension Array {
    func removeAt(_ index: Int) -> [Element] {
        if index >= 0 && index < self.count {
            let newArray = Array( self.prefix(index) + self.suffix(from: index + 1) )
            return newArray
        }
        return self
    }
}
