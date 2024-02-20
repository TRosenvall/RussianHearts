//
//  SettingsBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/21/23.
//

import Foundation

class SettingsBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any SettingsView {
        let view: any SettingsView = SettingsViewController()
        let worker: any SettingsWorker = SettingsWorkerImpl()

        view.worker = worker
        view.delegate = delegate

        return view
    }
}
