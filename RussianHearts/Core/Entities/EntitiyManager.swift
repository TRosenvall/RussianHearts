//
//  EntitiyManager.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/18/23.
//

import Foundation

class EntityManager: EntityManaging {

    // MARK: - Properties
    static let shared: EntityManaging = EntityManager()
    let entityAccessor: EntityAccessing
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    var loadedEntities: [Entity]

    // MARK: - Lifecycle
    init(entityAccessor: EntityAccessing = EntityAccessor(),
         decoder: JSONDecoder = JSONDecoder(),
         encoder: JSONEncoder = JSONEncoder(),
         loadedEntities: [Entity] = []) {
        self.entityAccessor = entityAccessor
        self.decoder = decoder
        self.encoder = encoder
        self.loadedEntities = loadedEntities
    }

    // MARK: - Conformance: EntityManaging

    func retrieveEntities() throws {
        for entity in EntityTypes.allCases {
            switch entity {
            case .Game: let _: GameEntity? = try retrieveEntity()
            }
        }
    }

    func retrieveEntity<T: Entity>() throws -> T? {
        for entity in loadedEntities where entity is T {
            return entity as? T
        }
        let data = try entityAccessor.retrieveData(forId: T.id)
        let entity: T? = try decode(data)
        guard let entity
        else {throw CodingErrors.entityNotFound }
        loadedEntities.append(entity)
        return entity
    }

    func decode<T: Decodable>(_ data: Data?) throws -> T? {
        guard let data else {
            throw CodingErrors.unableToRetrieveData
        }
        return try decoder.decode(T.self, from: data)
    }
    
    func encode<T: Encodable>(_ entity: T) throws -> Data? {
        return try encoder.encode(entity)
    }

    func save<T>(entity: T) throws where T : Entity {
        let data = try encode(entity)
        try entityAccessor.save(data, withId: T.id)
    }

    func update<T>(entity: T) throws where T : Entity {
        try delete(entity: entity)
        try save(entity: entity)
    }

    func delete<T: Entity>(entity: T) throws {
        let index = loadedEntities.firstIndex { loadedEntity in
            loadedEntity is T
        }
        if let index {
            print("Found entity in stack, removing")
            loadedEntities.remove(at: index)
        }
        try entityAccessor.removeEntity(withId: T.id)
    }
}
