//
//  BidModel.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import Foundation

class Bid: Codable {

    // MARK: - Properties
    var value: Int

    // MARK: - Lifecycle
    init(value: Int) {
        self.value = value
    }

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case value
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.value = try values.decode(Int.self, forKey: .value)
    }
}
