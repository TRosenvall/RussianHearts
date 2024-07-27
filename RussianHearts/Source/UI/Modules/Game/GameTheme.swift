//
//  GameTheme.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import Foundation
import SwiftUI

struct GameTheme: ModuleTheme {

    // MARK: - Properties

    let moduleBackgroundColor: Color

    let moduleAccentColor: Color

    // MARK: - Initializers

    init(
        assets: Assets,
        colors: Colors,
        moduleBackgroundColor: Color? = nil,
        moduleAccentColor: Color? = nil
    ) {
        Logger.default.log("Initializing Main Menu Theme")

        self.moduleBackgroundColor = moduleBackgroundColor ?? Color(uiColor: colors.backgroundColor)
        self.moduleAccentColor = moduleAccentColor ?? Color(uiColor: colors.gameAccent)
    }
}
