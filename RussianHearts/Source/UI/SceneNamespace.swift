//
//  SceneNamespace.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/22/23.
//

import UIKit

enum SceneError: Error {
    case noAppWindowFound
}

enum Module {
    case Launch
    case MainMenu
    case Tutorial
    case NewGame
    case Game
    case Highscore
    case Friends
    case Settings

    var id: String {
        switch self {
        case .Launch: return "com.russianhearts.launch"
        case .MainMenu: return "com.russianhearts.mainmenu"
        case .Tutorial: return "com.russianhearts.rules"
        case .NewGame: return "com.russianhearts.newgame"
        case .Game: return "com.russianhearts.game"
        case .Highscore: return "com.russianhearts.highscore"
        case .Friends: return "com.russianhearts.friends"
        case .Settings: return "com.russianhearts.settings"
        }
    }

    var color: UIColor {
        switch self {
        case .Launch: return .systemGray
        case .MainMenu: return .systemPink
        case .Tutorial: return .systemBrown
        case .NewGame: return .systemBlue
        case .Game: return .systemPurple
        case .Highscore: return .systemOrange
        case .Friends: return .systemGreen
        case .Settings: return .systemTeal
        }
    }
}

///------

protocol ModuleModelBase {}
