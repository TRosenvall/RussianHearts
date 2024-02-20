//
//  EntityAccessor.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/18/23.
//

import Foundation

protocol EntityAccessing: Model {

    /// Retreives all entities of a given type from the disk
    func loadAllEntities<T: Entity>() async throws -> [T]

    /// Retrieves the current active entity of a given type from the disk
    func loadActiveEntity<T: Entity>() async throws -> T

    /// Persists the current entity of a given type onto the disk
    func save<T: Entity>(entity: T) async throws

    /// Removes the entity of a given type from the disk
    func delete<T: Entity>(entity: T) async throws

    /// First removes the old copy of an entity persisted to disk before saving it again.
    func update<T: Entity>(entity: T) async throws

    /// Checks if a given entity has existing data or not. Returns true is saved data currently exists.
    func validateEntity<T: Entity>(_ entity: T) async throws -> Bool
}

struct EntityAccessor: EntityAccessing {

    // MARK: - Properties

    let id: UUID
    let fileManager: RHFileManager
    let encoder: RHEncoder
    let decoder: RHDecoder

    // MARK: - Lifecycle

    internal init(with base: EntityAccessor?, id: UUID?) {
        self.init(base: base, id: id)
    }

    fileprivate init(
        base: EntityAccessor? = nil,
        id: UUID? = nil,
        fileManager: RHFileManager? = nil,
        encoder: RHEncoder? = nil,
        decoder: RHDecoder? = nil
    ) {
        self.id = id ?? base?.id ?? UUID()
        self.fileManager = fileManager ?? base?.fileManager ?? RHFileManager()
        self.encoder = encoder ?? base?.encoder ?? RHEncoder()
        self.decoder = decoder ?? base?.decoder ?? RHDecoder()
    }

    // MARK: - Conformance: Model

    func validate() throws -> EntityAccessor {
        return self
    }

    // MARK: - Conformance: EntityAccessing

    func loadAllEntities<T: Entity>() async throws -> [T] {
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appURL = appSupportURL.appendingPathComponent(Constants.appShortName)

        let fileURLs = try fileManager.contentsOfDirectory(at: appURL, includingPropertiesForKeys: nil)

        let filteredURLs = fileURLs.filter { $0.lastPathComponent.hasPrefix(T.persistID) }

        return try await decodeEntityHelper(urls: filteredURLs)
    }

    func loadActiveEntity<T: Entity>() async throws -> T {
        let entities: [T] = try await loadAllEntities()

        return try await loadActiveEntityHelper(entities: entities)
    }

    func save<T: Entity>(entity: T) async throws {
        let data = try encoder.encode(entity)
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try fileManager.createDirectory(at: appSupportURL,
                                        withIntermediateDirectories: true)
        let appURL = appSupportURL.appendingPathComponent(Constants.appShortName)
        try FileManager.default.createDirectory(at: appURL,
                                                withIntermediateDirectories: true)

        let fileName = "\(T.persistID).\(entity.id).json"
        let fileURL = appURL.appendingPathComponent(fileName)

        try data.write(to: fileURL)
    }

    func delete<T: Entity>(entity: T) async throws {
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try fileManager.createDirectory(at: appSupportURL,
                                        withIntermediateDirectories: true)
        let appURL = appSupportURL.appendingPathComponent(Constants.appShortName)
        try FileManager.default.createDirectory(at: appURL,
                                                withIntermediateDirectories: true)

        let fileName = "\(T.persistID).\(entity.id).json"
        let fileURL = appURL.appendingPathComponent(fileName)
        try fileManager.removeItem(at: fileURL)
    }

    func update<T: Entity>(entity: T) async throws {
        try await self.delete(entity: entity)
        try await self.save(entity: entity)
    }

    func validateEntity<T: Entity>(_ entity: T) async throws -> Bool {
        // TODO: - Check if entity exists, return Bool if true
        return false
    }

    // MARK: - Helpers

    private func decodeEntityHelper<T: Entity>(urls: [URL],
                                       decodedEntities: [T] = []) async throws -> [T] {
        if let url = urls.first {
            let data = try Data(contentsOf: url)
            let entity = try decoder.decode(T.self, from: data)

            return try await decodeEntityHelper(urls: Array(urls[1...]),
                                                decodedEntities: decodedEntities + [entity])
        }
        return decodedEntities
    }

    private func loadActiveEntityHelper<T: Entity>(entities: [T]) async throws -> T {
        guard let entity: T = entities.first
        else { throw CodingErrors.entityNotFound }

        if entity.completionState == .active { return entity }

        return try await loadActiveEntityHelper(entities: Array(entities[1...]))
    }
}

extension GenericBuilder where T == EntityAccessor {
    func with(fileManager: RHFileManager?) -> GenericBuilder<EntityAccessor> {
        let newBase = EntityAccessor(base: base, fileManager: fileManager)
        return GenericBuilder<EntityAccessor>(base: newBase)
    }

    func with(encoder: RHEncoder?) -> GenericBuilder<EntityAccessor> {
        let newBase = EntityAccessor(base: base, encoder: encoder)
        return GenericBuilder<EntityAccessor>(base: newBase)
    }

    func with(decoder: RHDecoder?) -> GenericBuilder<EntityAccessor> {
        let newBase = EntityAccessor(base: base, decoder: decoder)
        return GenericBuilder<EntityAccessor>(base: newBase)
    }
}
