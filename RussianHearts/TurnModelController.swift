//
//  TurnModelController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/18/23.
//

import Foundation

let Turn = TurnModelController.shared
class TurnModelController {

    static let shared = TurnModelController()

    var activeTurn: TurnModel? {
        Phase.activePhase?.activeTurn
    }
}
