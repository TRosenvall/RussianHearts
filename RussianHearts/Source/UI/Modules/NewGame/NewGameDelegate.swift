//
//  NewGameDelegate.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import Foundation

protocol NewGameDelegate: ModuleDelegate {
    func routeToGame(with: GameEntity)
    func routeBack(animated: Bool)
}
