//
//  NewGameBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

class NewGameBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any NewGameView {
        let view: any NewGameView = NewGameViewController()
        let worker: NewGameWorker = NewGameWorkerImpl()

        view.worker = worker
        view.delegate = delegate

        return view
    }
}
