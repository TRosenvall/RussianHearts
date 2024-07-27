//
//  GameDelegate.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/19/24.
//

import Foundation

protocol GameDelegate: ModuleDelegate {
    func routeBackToMainMenu(from module: (any ModuleController)?)
    func routeToHighScores()
}
