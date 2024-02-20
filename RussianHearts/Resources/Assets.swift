//
//  Assets.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/14/23.
//

import UIKit

protocol Assets {}

struct RHAssets: Assets {
    static let appIcon = UIImage(named: "AppIcon")
    static let accentColor = UIColor(named: "AccentColor")
    static let backgroundColor = UIColor(named: "BackgroundColor")
}
