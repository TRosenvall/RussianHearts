//
//  ModuleFactory.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/15/23.
//

import Foundation

/// Holds all dependencies required for building new modules. Instantiates builders as needed
protocol ModuleFactory {

    /// Builds and returns a module of a given type
    func buildModule<T>(delegate: SceneCoordinating, gameEntity: GameEntity?) -> T?
}

struct ModuleFactoryImpl: ModuleFactory {

    // MARK: - Properties
    let assets: Assets
    let colors: Colors
    let entityAccessor: any EntityAccessing

    // MARK: - Lifecycle
    init(assets: Assets = RHAssets(),
         colors: Colors = RHColors(),
         entityAccessor: (any EntityAccessing)? = nil) {
        self.assets = assets
        self.colors = colors
        self.entityAccessor = entityAccessor ?? EntityAccessor()
    }

    // MARK: - Conformance: ModuleWorks

    func buildModule<T>(
        delegate: SceneCoordinating,
        gameEntity: GameEntity? = nil
    ) -> T? {
        Logger.default.log("Setting Up Builder For \(T.self)")

        do {
            // This is a really REALLY hacky way of doing this, but it's sufficient for the project.
            switch "\(T.self)" {
            case "\((any LaunchHost).self)":
                return try LaunchBuilder().build(
                    delegate: delegate,
                    assets: assets,
                    colors: colors, 
                    entityAccessor: entityAccessor
                ) as? T
            case "\((any MainMenuHost).self)":
                return try MainMenuBuilder().build(
                    delegate: delegate,
                    assets: assets,
                    colors: colors,
                    entityAccessor: entityAccessor
                ) as? T
            case "\((any NewGameHost).self)":
                return try NewGameBuilder().build(
                    delegate: delegate,
                    assets: assets,
                    colors: colors,
                    entityAccessor: entityAccessor
                ) as? T
            case "\((any GameHost).self)":
                guard let gameEntity
                else { Logger.default.logFatal("Attempting to instantiate GameHost Builder without GameEntity") }

                return try GameBuilder().build(
                    delegate: delegate,
                    assets: assets,
                    colors: colors,
                    entityAccessor: entityAccessor, 
                    gameEntity: gameEntity
                ) as? T
            case "\((any HighscoresView).self)":
                return HighscoresBuilder().build(delegate: delegate) as? T
            case "\((any RulesView).self)":
                return RulesBuilder().build(delegate: delegate) as? T
            case "\((any FriendsView).self)":
                return FriendsBuilder().build(delegate: delegate) as? T
            case "\((any SettingsView).self)":
                return SettingsBuilder().build(delegate: delegate) as? T
            default:
                Logger.default.logFatal("Module \(T.self) Not Implemented")
            }
        } catch {
            Logger.default.logFatal("Building Module Failed, \(error)")
        }
    }
}
