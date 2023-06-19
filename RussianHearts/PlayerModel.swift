//
//  PlayerModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import Foundation

class PlayerModel: Equatable {
    var cards: [Card] = []
    var name: String
    var activeBid: Bid? = nil
    var score: Int = 0
    var id: Int

    init(name: String,
         id: Int) {
        self.name = name
        self.id = id
    }

    static func == (lhs: PlayerModel, rhs: PlayerModel) -> Bool {
        return lhs.id == rhs.id
    }
}
