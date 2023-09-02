//
//  UIContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import UIKit

/// Conforms to the delegate function of all the modules and handles coordination logic
/// between scenes.
protocol SceneCoordinating:
    LaunchDelegate,
    MainMenuDelegate,
    NewGameDelegate
{
    /// Start the app and route to the first module
    func start()
}

/// Handles specifics of routing logic. Also holds the `RootViewController` and associated
/// navigation stack.
protocol SceneWireframe {

    /// Coordinating delegate used in routing
    var delegate: SceneCoordinating? { get set }

    /// Route to launch module
    func routeToLaunchModule()

    /// Route to main menu
    func routeToMainMenu()

    /// Route to new game module
    func routeToNewGameModule()

    func dismiss(animated: Bool)
}
