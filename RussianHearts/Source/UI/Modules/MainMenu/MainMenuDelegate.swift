//
//  MainMenuDelegate.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/3/24.
//

import Foundation

protocol MainMenuDelegate: ModuleDelegate {
    func routeToNewGame()
    func routeToGame(with entity: GameEntity?)
    func routeToRules()
    func routeToHighScores()
    func routeToFriends()
    func routeToSettings()
}

extension MainMenuDelegate {
    func routeToGame(with entity: GameEntity? = nil) {
        routeToGame(with: entity)
    }
}
