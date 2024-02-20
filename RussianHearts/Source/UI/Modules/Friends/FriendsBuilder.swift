//
//  FriendsBuilder.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/21/23.
//

import Foundation

class FriendsBuilder {
    
    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Helper Functions
    func build(delegate: SceneCoordinating) -> any FriendsView {
        let view: any FriendsView = FriendsViewController()
        let worker: any FriendsWorker = FriendsWorkerImpl()

        view.worker = worker
        view.delegate = delegate

        return view
    }
}
