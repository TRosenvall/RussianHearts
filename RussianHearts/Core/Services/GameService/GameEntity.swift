//
//  GameEntity.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

class GameEntity: Entity {

    // MARK: - Properties
    static var id: String = "com.russianhearts.gameentity"

    var savedGames: [GameModel]?

    // MARK: - Lifecycle
    init(savedGames: [GameModel]? = nil) {
        self.savedGames = savedGames
    }

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case savedGames
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.savedGames = try values.decode([GameModel]?.self, forKey: .savedGames)
    }
}
