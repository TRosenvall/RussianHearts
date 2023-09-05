//
//  GameModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

// Needed this to be available outside of self.
func rotate(players: inout [PlayerModel]) {
    let player = players.remove(at: 0)
    players.append(player)
}

class GameModel: Codable {

    // MARK: - Properties
    var id: String
    var rounds: [RoundModel]
    var activeRound: RoundModel
    var players: [PlayerModel]
    var endOfGame: Bool

    // MARK: - Lifecycle
    init(players: [PlayerModel]) {

        self.id = UUID().uuidString
        self.players = players
        self.endOfGame = false

        guard let player1 = self.players.first
        else {
            fatalError("No Players Passed In")
        }

        let round1 = RoundModel(roundName: "Round One",
                                numberOfCardsToPlay: 7,
                                players: players)

        rotate(players: &self.players)
        let round2 = RoundModel(roundName: "Round Two",
                                numberOfCardsToPlay: 5,
                                players: players)

        rotate(players: &self.players)
        let round3 = RoundModel(roundName: "Round Three",
                                numberOfCardsToPlay: 3,
                                players: players)

        rotate(players: &self.players)
        let round4 = RoundModel(roundName: "Round Four",
                                numberOfCardsToPlay: 1,
                                players: players)

        rotate(players: &self.players)
        let round5 = RoundModel(roundName: "Round Five",
                                numberOfCardsToPlay: 2,
                                players: players)

        rotate(players: &self.players)
        let round6 = RoundModel(roundName: "Round Six",
                                numberOfCardsToPlay: 4,
                                players: players)

        rotate(players: &self.players)
        let round7 = RoundModel(roundName: "Round Seven",
                                numberOfCardsToPlay: 6,
                                players: players)

        self.rounds = [round1, round2, round3, round4, round5, round6, round7]
        self.activeRound = rounds.first!
    }

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case id
        case rounds
        case activeRound
        case players
        case endOfGame
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.rounds = try values.decode([RoundModel].self, forKey: .rounds)
        self.activeRound = try values.decode(RoundModel.self, forKey: .activeRound)
        self.players = try values.decode([PlayerModel].self, forKey: .players)
        self.endOfGame = try values.decode(Bool.self, forKey: .endOfGame)
    }

    // MARK: - Helpers
}
