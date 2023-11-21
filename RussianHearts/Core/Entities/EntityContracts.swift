//
//  EntityContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/18/23.
//

import Foundation

protocol Entity: Codable {
    static var id: String { get }
}

protocol EntityManaging {

    /// Read and write data to disk
    var entityAccessor: EntityAccessing { get }

    /// Iterates through all entity types and loads them into memory
    func retrieveEntities() async throws

    /// Retrieves a specific piece of data based on entity type
    func retrieveEntity<T: Entity>() throws -> T?

    /// Decodes data into entity
    func decode<T: Decodable>(_ data: Data?) throws -> T?

    /// Encodes entity into data
    func encode<T: Encodable>(_ entity: T) throws -> Data?

    /// Saves an entity to the local datastore
    func save<T: Entity>(entity: T) throws

    // Updates an existing entity
    func update<T: Entity>(entity: T) throws

    // Removes entity from datastore
    func delete<T: Entity>(entity: T) throws

}

protocol EntityAccessing {

    /// Retreives data from disk
    func retrieveData(forId id: String) throws -> Data?

    /// Saves data to disk
    func save(_ data: Data?, withId id: String) throws

    /// Removes entity from datastore
    func removeEntity(withId id: String) throws
}
