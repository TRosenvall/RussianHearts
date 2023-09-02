//
//  LaunchRouter.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/17/23.
//

import Foundation

class LaunchRouter: LaunchWireframe {

    // MARK: - Properties
    var delegate: LaunchDelegate

    // MARK: - Lifecycle
    init(delegate: LaunchDelegate) {
        self.delegate = delegate
    }

    // MARK: - Conformance: LaunchWireframe
    func routeToMainApplication() {
        delegate.routeToMainApplication()
    }
}
