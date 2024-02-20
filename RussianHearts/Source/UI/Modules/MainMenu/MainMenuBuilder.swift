//
//  MainMenuBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

class MainMenuBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any MainMenuView {
        let view: any MainMenuView = MainMenuViewController()
        var worker: MainMenuWorker = MainMenuWorkerImpl()

        view.worker = worker
        view.delegate = delegate

        return view
    }
}
