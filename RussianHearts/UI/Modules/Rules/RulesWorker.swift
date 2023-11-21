//
//  RulesWorker.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/21/23.
//

import Foundation

// Called on by presenter to do peices of work
protocol RulesWorker: ModuleWorker {}

class RulesWorkerImpl: RulesWorker {

    // MARK: - Properties
    var serviceManager: ServiceManaging

    // MARK: - Lifecycle
    init(serviceManager: ServiceManaging = ServiceManager.shared) {
        self.serviceManager = serviceManager
    }

    // MARK: - Conformance: ModuleWorker

    // MARK: - Helpers
}
