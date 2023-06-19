//
//  RoundModelController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/18/23.
//

import Foundation

let Round = RoundModelController.shared
class RoundModelController {

    static let shared = RoundModelController()

    var activeRound: RoundModel? {
        Game.activeGame?.activeRound
    }

    func nextPhase() {
        let currPhase = Phase.activePhase
        if currPhase != activeRound?.phases.last {
            let index = activeRound!.phases.firstIndex(of: currPhase!)
            activeRound?.activePhase = activeRound!.phases[index! + 1]
        } else {
            Game.nextRound()
        }
    }
}
