//
//  RulesBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/21/23.
//

import Foundation

class RulesBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any RulesView {
        let view: any RulesView = RulesViewController()
        let worker: any RulesWorker = RulesWorkerImpl()

        view.worker = worker
        view.delegate = delegate

        return view
    }
}
