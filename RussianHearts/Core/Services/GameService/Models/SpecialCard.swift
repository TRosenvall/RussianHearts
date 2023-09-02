//
//  SpecialCard.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import UIKit

protocol NamingScheme {
    var lowJoker: String { get }
    var highJoker: String { get }
    var lowCard: String { get }
    var highCard: String { get }
}

extension NamingScheme {
    // Will return the Value of the variable.
    func getValue(withName name: SpecialCardType) -> String? {
        let mirror = Mirror(reflecting: self)
        let child = mirror.children.filter { child in
            return child.label == name.rawValue
        }
        return child.first?.value as? String
    }
}

// To add additional card names, add an additional struct within this one and
// update the NamingSchemes enum and rawValue function below.
class SpecialCardName {
    struct StandardNaming: NamingScheme {
        let lowJoker = "Low Joker"
        let highJoker = "High Joker"
        let lowCard = "Low Card"
        let highCard = "High Card"
    }

    struct DefaultNaming: NamingScheme {
        let lowJoker = "Priest"
        let highJoker = "Tzar"
        let lowCard = "Orphan"
        let highCard = "Cassock"
    }

    // This one is a plural NamingSchemes vs the protocol is singular NamingScheme
    enum NamingSchemes {
        case standardNaming
        case defaultNaming
    }

    private var activeNamingScheme: NamingSchemes = .defaultNaming

    func updateNamingScheme(to scheme: NamingSchemes) {
        activeNamingScheme = scheme
    }

    func rawValue(forType type: SpecialCardType) -> String {
        switch activeNamingScheme {
        case .standardNaming:
            return StandardNaming().getValue(withName: type)!
        case .defaultNaming:
            return DefaultNaming().getValue(withName: type)!
        }
    }
}

enum SpecialCardType: String, CaseIterable, Codable {
    case lowJoker = "lowJoker"
    case highJoker = "highJoker"
    case lowCard = "lowCard"
    case highCard = "highCard"
}

class SpecialCard: Card {

    // MARK: Properties
    var type: SpecialCardType
    var image: UIImage
    var name: String

    // MARK: - Lifecycle
    init(type: SpecialCardType) {
        self.type = type
        self.name = SpecialCardName().rawValue(forType: type)
        self.image = Assets.image(for: self.name)
        super.init()
    }

    // MARK: - Conformance: Codable
    enum CodingKeys: CodingKey {
        case type
        case name
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try values.decode(SpecialCardType.self, forKey: .type)
        self.name = try values.decode(String.self, forKey: .name)
        self.image = Assets.image(for: self.name)
        try super.init(from: decoder)
    }
}
