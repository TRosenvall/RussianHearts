//
//  RoundModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

class RoundModel: Equatable {

    var roundName: String
    var numberOfCardsToPlay: Int
    var bidsByPlayer: [(bid: Bid, player: PlayerModel)]
    var trump: Card?
    var phases: [PhaseModel] = []
    var activePhase: PhaseModel

    init(roundName: String,
         numberOfCardsToPlay: Int,
         players: [PlayerModel]) {
        self.roundName = roundName
        self.numberOfCardsToPlay = numberOfCardsToPlay
        self.bidsByPlayer = []

        var mutatingPlayers = players

        // Setup bidding phase
        let biddingPhase = PhaseModel(players: mutatingPlayers, id: 0)
        self.phases.append(biddingPhase)

        // Iterate through players and setup phases based on player order.
        for i in 1...numberOfCardsToPlay {
            let newPhase = PhaseModel(players: mutatingPlayers, id: i)
            self.phases.append(newPhase)

            let player1 = mutatingPlayers.remove(at: 0)
            mutatingPlayers.append(player1)
        }

        self.activePhase = phases.first!
    }

    static func == (lhs: RoundModel, rhs: RoundModel) -> Bool {
        return lhs.roundName == rhs.roundName
    }
}
