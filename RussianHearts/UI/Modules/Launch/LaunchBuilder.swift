//
//  LaunchBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/17/23.
//

import Foundation

class LaunchBuilder {

    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any LaunchView {
        let view: any LaunchView = LaunchViewController()
        var worker: any LaunchWorker = LaunchWorkerImpl()

        view.worker = worker
        view.delegate = delegate

        return view
    }
}
