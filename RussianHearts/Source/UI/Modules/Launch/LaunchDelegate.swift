//
//  LaunchDelegate.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/3/24.
//

import Foundation

protocol LaunchDelegate: ModuleDelegate {
    func routeToMainMenu(with entity: GameEntity?)
}

extension LaunchDelegate {
    func routeToMainMenu(with entity: GameEntity? = nil) {
        routeToMainMenu(with: entity)
    }
}
