//
//  CardModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/11/23.
//

import Foundation

class Card: Codable, Equatable {

    // MARK: - Properties
    var id: String = UUID().uuidString

    // MARK: - Lifecycle
    init() {}

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case id
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
    }

    // MARK: - Conformance: Equatable
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}
