//
//  ModuleFactory.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import Foundation

class ModuleFactory: ModuleWorks {

    // MARK: - Properties

    // MARK: - Lifecycle

    // MARK: - Conformance: ModuleWorks

    func buildModule<T>(delegate: SceneCoordinating) -> T? {
        // This is a really REALLY hacky way of doing this, but it's sufficient for the project.
        switch "\(T.self)" {
        case "\((any LaunchView).self)":
            return LaunchBuilder().build(delegate: delegate) as? T
        case "\((any MainMenuView).self)":
            return MainMenuBuilder().build(delegate: delegate) as? T
        case "\((any NewGameView).self)":
            return NewGameBuilder().build(delegate: delegate) as? T
        case "\((any GameView).self)":
            return GameBuilder().build(delegate: delegate) as? T
        case "\((any HighscoresView).self)":
            return HighscoresBuilder().build(delegate: delegate) as? T
        default:
            fatalError("Couldn't resolve module")
        }
    }
}
