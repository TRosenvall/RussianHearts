//
//  Colors.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/4/24.
//

import UIKit

protocol Colors {
    // Shared Colors
    var backgroundColor: UIColor { get }
    var textColor: UIColor { get }

    // Status Colors
    var success: UIColor { get }
    var warning: UIColor { get }
    var failure: UIColor { get }

    // Module Accents
    var launchAccent: UIColor { get }
    var mainMenuAccent: UIColor { get }
    var newGameAccent: UIColor { get }
    var gameAccent: UIColor { get }
}

struct RHColors: Colors {

    // Shared Colors
    let backgroundColor: UIColor = UIColor(named: "ModuleBackground")!
    let textColor: UIColor = UIColor(named: "Text")!

    // Status Colors
    let success: UIColor = UIColor(named: "Success")!
    let warning: UIColor = UIColor(named: "Warning")!
    let failure: UIColor = UIColor(named: "Failure")!

    // Module Accents
    let launchAccent: UIColor = UIColor(named: "LaunchAccent")!
    let mainMenuAccent: UIColor = UIColor(named: "MainMenuAccent")!
    let newGameAccent: UIColor = UIColor(named: "NewGameAccent")!
    let gameAccent: UIColor = UIColor(named: "GameAccent")!
}
