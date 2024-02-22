//
//  LaunchHostingController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import UIKit
import SwiftUI

// Determines how to call on required dependencies for routing
protocol LaunchHost: ModuleController {}

class LaunchHostingController: UIHostingController<LaunchViewImpl>, LaunchHost {

    // MARK: - Properties

    var module: Module = .Launch
    var shouldRelease: Bool = false

    // MARK: - Lifecycle

    init(viewModel: LaunchViewModelImpl) {
        Logger.default.log("Initializing Launch Host")

        guard let view = viewModel.view
        else { Logger.default.logFatal("Launch View Model Missing View") }

        super.init(rootView: view)
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        Logger.default.logFatal("init(coder:) has not been implemented")
    }
}

