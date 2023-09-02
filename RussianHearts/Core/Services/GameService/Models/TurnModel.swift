//
//  TurnModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

class TurnModel: Equatable, Codable {

    // MARK: - Properties
    var activePlayer: PlayerModel

    // MARK: - Lifecycle
    init(activePlayer: PlayerModel) {
        self.activePlayer = activePlayer
    }

    // MARK: - Conformance: Equatable
    static func == (lhs: TurnModel, rhs: TurnModel) -> Bool {
        return lhs.activePlayer == rhs.activePlayer
    }

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case activePlayer
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.activePlayer = try values.decode(PlayerModel.self, forKey: .activePlayer)
    }
}
