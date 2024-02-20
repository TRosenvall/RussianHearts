//
//  Bid.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import Foundation

// MARK: - Object
struct Bid: Model {

    // MARK: - Properties
    let id: UUID
    let value: Int?
    let forPlayerWithID: UUID?

    // MARK: - Lifecycle
    internal init(with base: Bid?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(base: Bid? = nil,
                     id: UUID? = nil,
                     value: Int? = nil,
                     forPlayerWithID: UUID? = nil) {
        self.id = id ?? base?.id ?? UUID()
        self.value = value ?? base?.value
        self.forPlayerWithID = forPlayerWithID ?? base?.forPlayerWithID
    }

    // MARK: - Helpers
    func validate() throws -> Bid {
        guard value != nil, forPlayerWithID != nil
        else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

        return self
    }
}

// MARK: - Builder Extension
extension GenericBuilder where T == Bid {
    func with(value: Int) -> GenericBuilder<Bid> {
        let newBase = Bid(base: base, value: value)
        return GenericBuilder<Bid>(base: newBase)
    }

    func with(playerID: UUID) -> GenericBuilder<Bid> {
        let newBase = Bid(base: base, forPlayerWithID: playerID)
        return GenericBuilder<Bid>(base: newBase)
    }
}
