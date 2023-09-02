//
//  LaunchInteractor.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/17/23.
//

import Foundation

class LaunchInteractor: LaunchInput {

    // MARK: - Properties
    var output: LaunchOutput?
    var entityManager: EntityManaging

    // MARK: - Lifecycle
    init(entityManager: EntityManaging = EntityManager.shared) {
        self.entityManager = entityManager
    }

    // MARK: - Conformance: LaunchInput
    func loadData(from type: DataStorageType) throws {
        try entityManager.retrieveEntities()
        output?.routeToMainApplication()
    }
}
