//
//  TurnModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

class TurnModel: Equatable {

    var activePlayer: PlayerModel

    init(activePlayer: PlayerModel) {
        self.activePlayer = activePlayer
    }

    static func == (lhs: TurnModel, rhs: TurnModel) -> Bool {
        return lhs.activePlayer == rhs.activePlayer
    }
}
