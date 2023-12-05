//
//  PlayerModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import Foundation

class PlayerModel: Equatable, Codable {

    // MARK: - Properties
    var cards: [Card] = []
    var name: String
    var activeBid: Bid? = nil
    var score: Int = 0
    var scoreTotal: Int = 0
    var id: Int
    var isHuman: Bool

    // MARK: - Lifecycle
    init(name: String,
         id: Int,
         isHuman: Bool) {
        self.name = name
        self.id = id
        self.isHuman = isHuman
    }

    // MARK: - Conformance: Equatable
    static func == (lhs: PlayerModel, rhs: PlayerModel) -> Bool {
        return lhs.id == rhs.id
    }

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case cards
        case name
        case activeBid
        case score
        case id
        case isHuman
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.cards = try values.decode([Card].self, forKey: .cards)
        self.name = try values.decode(String.self, forKey: .name)
        self.activeBid = try values.decode(Bid?.self, forKey: .activeBid)
        self.score = try values.decode(Int.self, forKey: .score)
        self.id = try values.decode(Int.self, forKey: .id)
        self.isHuman = try values.decode(Bool.self, forKey: .isHuman)
    }
}
