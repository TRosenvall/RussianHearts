//
//  PhaseModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/18/23.
//

import Foundation

class PhaseModel: Equatable, Codable {

    struct CardsPlayedByPlayer: Codable {
        var card: Card
        var player: PlayerModel
    }

    // MARK: - Properties
    var turns: [TurnModel] = []
    var activeTurn: TurnModel
    var cardsPlayedByPlayer: [CardsPlayedByPlayer]
    var id: Int

    // MARK: - Lifecycle
    init(players: [PlayerModel],
         id: Int) {
        self.cardsPlayedByPlayer = []

        for player in players {
            let turn = TurnModel(activePlayer: player)
            turns.append(turn)
        }

        self.activeTurn = turns.first!
        self.id = id
    }

    // MARK: - Conformance: Equatable
    static func == (lhs: PhaseModel, rhs: PhaseModel) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case turns
        case activeTurn
        case cardsPlayedByPlayer
        case id
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.turns = try values.decode([TurnModel].self, forKey: .turns)
        self.activeTurn = try values.decode(TurnModel.self, forKey: .activeTurn)
        self.cardsPlayedByPlayer = try values.decode([CardsPlayedByPlayer].self, forKey: .cardsPlayedByPlayer)
        self.id = try values.decode(Int.self, forKey: .id)
    }
}
