//
//  PhaseModelController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/18/23.
//

import Foundation

let Phase = PhaseModelController.shared
class PhaseModelController {

    static let shared = PhaseModelController()

    var activePhase: PhaseModel? {
        Round.activeRound?.activePhase
    }

    func nextTurn() {
        let currTurn = Turn.activeTurn
        if currTurn != activePhase?.turns.last {
            let index = activePhase!.turns.firstIndex(of: currTurn!)
            activePhase?.activeTurn = activePhase!.turns[index! + 1]
        } else {
            Round.nextPhase()
        }
    }

    func isLastTurnInPhase() -> Bool {
        let currTurn = Turn.activeTurn
        if currTurn == activePhase?.turns.last {
            return true
        }
        return false
    }
}
