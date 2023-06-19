//
//  GameModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

class GameModel {
    var rounds: [RoundModel]
    var activeRound: RoundModel

    init() {
        var mutatingPlayers: [PlayerModel] = Game.players
        let round1 = RoundModel(roundName: "Round One", numberOfCardsToPlay: 7, players: mutatingPlayers)

        var player1 = mutatingPlayers.remove(at: 0)
        mutatingPlayers.append(player1)
        let round2 = RoundModel(roundName: "Round Two", numberOfCardsToPlay: 5, players: mutatingPlayers)

        player1 = mutatingPlayers.remove(at: 0)
        mutatingPlayers.append(player1)
        let round3 = RoundModel(roundName: "Round Three", numberOfCardsToPlay: 3, players: mutatingPlayers)

        player1 = mutatingPlayers.remove(at: 0)
        mutatingPlayers.append(player1)
        let round4 = RoundModel(roundName: "Round Four", numberOfCardsToPlay: 1, players: mutatingPlayers)

        player1 = mutatingPlayers.remove(at: 0)
        mutatingPlayers.append(player1)
        let round5 = RoundModel(roundName: "Round Five", numberOfCardsToPlay: 2, players: mutatingPlayers)

        player1 = mutatingPlayers.remove(at: 0)
        mutatingPlayers.append(player1)
        let round6 = RoundModel(roundName: "Round Six", numberOfCardsToPlay: 4, players: mutatingPlayers)

        player1 = mutatingPlayers.remove(at: 0)
        mutatingPlayers.append(player1)
        let round7 = RoundModel(roundName: "Round Seven", numberOfCardsToPlay: 6, players: mutatingPlayers)

        self.rounds = [round1, round2, round3, round4, round5, round6, round7]
        self.activeRound = rounds.first!
    }
}
