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
    var playedByPlayerWithId: Int?
    var isDisabled: Bool = false
    var tappedState: CardTappedState = .notTapped
    var selectedState: CardSelectedState = .notSelected

    // MARK: - Lifecycle
    init() {}

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case id
        case isDisabled
        case tappedState
        case selectedState
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.isDisabled = try values.decode(Bool.self, forKey: .isDisabled)
        self.tappedState = try values.decode(CardTappedState.self, forKey: .tappedState)
        self.selectedState = try values.decode(CardSelectedState.self, forKey: .selectedState)
    }

    // MARK: - Conformance: Equatable
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}
