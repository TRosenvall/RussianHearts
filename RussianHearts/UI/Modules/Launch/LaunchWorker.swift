//
//  LaunchWorker.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/18/23.
//

import Foundation

protocol LaunchWorker {
    func loadData(from type: DataStorageType) async throws
}

class LaunchWorkerImpl: LaunchWorker {

    // MARK: - Properties
    var entityManager: EntityManaging

    // MARK: - Lifecycle
    init(entityManager: EntityManaging = EntityManager.shared) {
        self.entityManager = entityManager
    }

    // MARK: - Conformance: LaunchInput
    func loadData(from type: DataStorageType) async throws {
        try await entityManager.retrieveEntities()
    }
}
