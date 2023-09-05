//
//  Constants.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 7/9/23.
//

import Foundation

let C = Constants.shared
class Constants {

    static let shared = Constants()

    let appShortName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
}
