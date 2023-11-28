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
    var players: [PlayerModel]
    var firstPlayerId: Int? {
        didSet {
            if let firstPlayerId, firstPlayerId != 0 {
                turns = []

                while players.first?.id != firstPlayerId {
                    rotate(players: &players)
                }

                for player in players {
                    let turn = TurnModel(activePlayer: player)
                    turns.append(turn)
                }

                self.activeTurn = turns[0]
            }
        }
    }

    // MARK: - Lifecycle
    init(players: [PlayerModel],
         id: Int,
         firstPlayerId: Int?) {
        self.players = players
        self.firstPlayerId = firstPlayerId
        self.cardsPlayedByPlayer = []

        for player in players {
            let turn = TurnModel(activePlayer: player)
            turns.append(turn)
        }

        self.activeTurn = turns[0]
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
        case players
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.turns = try values.decode([TurnModel].self, forKey: .turns)
        self.activeTurn = try values.decode(TurnModel.self, forKey: .activeTurn)
        self.cardsPlayedByPlayer = try values.decode([CardsPlayedByPlayer].self, forKey: .cardsPlayedByPlayer)
        self.players = try values.decode([PlayerModel].self, forKey: .players)
        self.id = try values.decode(Int.self, forKey: .id)
    }
}
