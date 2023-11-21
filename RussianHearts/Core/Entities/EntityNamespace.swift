//
//  EntityNamespace.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import Foundation

enum EntityTypes: CaseIterable {
    case Game
}

enum DataStorageType {
    case local
    case cloud
}

enum CodingErrors: Error {
    case unableToRetrieveData
    case entityNotFound
}
