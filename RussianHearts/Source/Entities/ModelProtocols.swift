//
//  ModelProtocols.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 12/20/23.
//

import Foundation

enum ModelError: Error {
    case requiredModelPropertiesNotSet(onType: Any.Type)
}

// MARK: - Builder Protocol

protocol Builder {

    /// The type of the model associated with the builder.
    associatedtype T: Model

    /// The type of coding container used for the model.
    associatedtype CodingContainer = T.CodingContainer

    /// A base value of a model which can be manipulated as needed
    var base: T { get }

    /// An initializer used to revert a model back to it's builder.
    init(base: T?)

    /// The function which will initialize and return the given model.
    func build() throws -> T
}

// MARK: - Model Protocol

/// As long as the variables are optional, or default values are provided for them,
/// no additional code is required for the models to conform to Codable
protocol Model: Equatable, Hashable, Codable {

    /// A hashable type used to facitate proper ids for each model.
    associatedtype ID: Hashable = UUID

    /// Provides a builder type for the model.
    associatedtype R: Builder

    /// The coding container type + it's default
    associatedtype CodingContainer: CodingContainerType = TypeContainer

    /// The entity associated with that specific model.
    associatedtype AssociatedEntity: Entity

    /// Provide a generic builder for our models which we can extend as needed
    static var Builder: R { get }

    /// A unique ID used for making the model Equatable and Hashable
    var id: ID { get }

    /// A required initializer used within the builders.
    init(with base: Self?, id: ID?)

    /// A function which is used to validate that the needed properties have been set on the object.
    func validate() throws -> Self
}

// Default implementations for the Model protocol.
extension Model {
    init(with base: Self? = nil, id: ID? = nil) {
        self.init(with: base, id: id)
    }
}

extension Model {
    func toBuilder() -> R {
        return R.init(base: self as? Self.R.T)
    }
}

// A defined Builder type with an associated type set for each model.
class GenericBuilder<T: Model>: Builder {

    // MARK: - Properties
    internal let base: T

    // MARK: - Lifecycle
    required init(base: T? = nil) {
        self.base = base ?? T()
    }

    // MARK: - Helpers
    func with(base: T) -> GenericBuilder<T> {
        let newBase = T(with: base)
        return GenericBuilder<T>(base: newBase)
    }

    func update(id: T.ID) -> GenericBuilder<T> {
        let newBase = T(with: base, id: id)
        return GenericBuilder<T>(base: newBase)
    }

    func build() throws -> T {
        Logger.default.log("Building \(T.self)")

        return try T(with: base).validate()
    }
}

// Gives the Model type access to the GenericBuilder
extension Model {
    static var Builder: GenericBuilder<Self> {
        return GenericBuilder<Self>()
    }
}

// MARK: - Equatable
extension Model {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Model {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
