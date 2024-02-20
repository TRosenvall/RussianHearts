//
//  LaunchTheme.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import SwiftUI
import UIKit

struct LaunchTheme: ModuleTheme {

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
        Logger.default.log("Initializing Launch Theme")

        self.moduleBackgroundColor = moduleBackgroundColor ?? Color(uiColor: colors.backgroundColor)
        self.moduleAccentColor = moduleAccentColor ?? Color(uiColor: colors.launchAccent)
    }
}
