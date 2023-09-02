//
//  ApplicationSceneContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/13/23.
//

import UIKit

protocol ApplicationWireframe {

    // Instance of module factory used to resolve new modules
    var moduleFactory: ModuleFactory { get set }

    // The root view controller on which new views are to be displayed
    var rootViewController: UIViewController? { get set }

    // Routes the application to the launch module
    func routeToLaunchModule()
}

protocol ApplicationCoordinator: LaunchDelegate {
    var router: ApplicationWireframe { get set }

    func initializeMainApplication(windowScene: UIWindowScene)
}
