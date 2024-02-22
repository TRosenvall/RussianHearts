//
//  SpecialCard.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 12/24/23.
//

import Foundation

enum SpecialCardType: String, CaseIterable, Codable {
    case lowJoker = "lowJoker"
    case highJoker = "highJoker"
    case lowCard = "lowCard"
    case highCard = "highCard"
}

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
struct SpecialCardName {
    struct DefaultNaming: NamingScheme {
        let lowJoker = "Low Joker"
        let highJoker = "High Joker"
        let lowCard = "Low Card"
        let highCard = "High Card"
    }

    struct ThemedNaming: NamingScheme {
        let lowJoker = "Priest"
        let highJoker = "Tzar"
        let lowCard = "Orphan"
        let highCard = "Cassock"
    }

    // This one is a plural NamingSchemes vs the protocol is singular NamingScheme
    enum NamingSchemes {
        case defaultNaming
        case themedNaming
    }

    // MARK: - Properties
    static let sharedInstance = SpecialCardName()

    // TODO: - Make this a settings value so that we can change or update the theming of the cards
    private var activeNamingScheme: NamingSchemes

    // MARK: - Lifecycle
    private init() {
        self.activeNamingScheme = .defaultNaming
    }

    mutating func updateNamingScheme(to scheme: NamingSchemes) {
        activeNamingScheme = scheme
    }

    func rawValue(forType type: SpecialCardType?) -> String? {
        guard let type
        else { return nil }

        switch activeNamingScheme {
        case .defaultNaming:
            return DefaultNaming().getValue(withName: type)
        case .themedNaming:
            return ThemedNaming().getValue(withName: type)
        }
    }
}

struct SpecialCard: CardProtocol {

    // MARK: Properties

    typealias AssociatedEntity = GameEntity

    let id: UUID
    var type: SpecialCardType?
    var name: String?
    let playedBy: Player?

    // MARK: - Lifecycle
    internal init(with base: SpecialCard?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: SpecialCard? = nil,
                     id: UUID? = nil,
                     type: SpecialCardType? = nil,
                     playedBy player: Player? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.type = type ?? base?.type
        // TODO: - This eventually needs to be pulled from a settings object.
        // I've made this a singleton for now but I don't like it.
        self.name = SpecialCardName.sharedInstance.rawValue(forType: type) ?? nil
        self.playedBy = player ?? base?.playedBy
    }

    // MARK: - Helpers
    func validate() throws -> SpecialCard {
        guard type != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }

    func wrap() -> Card {
        return .special(card: self)
    }
}

extension Array where Element == SpecialCard {
    private enum TypeNumber: Int {
        case lowCard = 1
        case highCard = 2
        case lowJoker = 3
        case highJoker = 4
    }

    private func transform(_ type: SpecialCardType) -> TypeNumber {
        switch type {
        case .lowCard: return .lowCard
        case .highCard: return .highCard
        case .lowJoker: return .lowJoker
        case .highJoker: return .highJoker
        }
    }

    func sort() throws -> [SpecialCard] {
        let sortedCards = try self.sorted { firstCard, secondCard in
            guard let firstCardType = firstCard.type
            else { throw ModelError.requiredModelPropertiesNotSet(onType: SpecialCardType.self) }

            guard let secondCardType = secondCard.type
            else { throw ModelError.requiredModelPropertiesNotSet(onType: SpecialCardType.self) }

            return transform(firstCardType).rawValue < transform(secondCardType).rawValue
        }

        return sortedCards
    }
}

// MARK: - Special Card Builder
extension GenericBuilder where T == SpecialCard {
    func with(type: SpecialCardType) -> GenericBuilder<SpecialCard> {
        let newBase = SpecialCard(base: base, type: type)
        return GenericBuilder<SpecialCard>(base: newBase)
    }

    func playedBy(_ player: Player) -> GenericBuilder<SpecialCard> {
        let newBase = SpecialCard(base: base, playedBy: player)
        return GenericBuilder<SpecialCard>(base: newBase)
    }
}
