//
//  HighscoresBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/19/23.
//

import Foundation

class HighscoresBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any HighscoresView {
        let view: any HighscoresView = HighscoresViewController()
        let worker: any HighscoresWorker = HighscoresWorkerImpl()

        view.worker = worker
        view.delegate = delegate

        return view
    }
}
