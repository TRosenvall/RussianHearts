//
//  ServiceFactory.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/18/23.
//

import Foundation

class ServiceFactory: ServiceWorks {

    // MARK: - Properties

    // MARK: - Lifecycle
    init() {}

    // MARK: - Conformance: ServiceWorks
    func buildService<T>() -> T? {
        // This is a really REALLY hacky way of doing this, but it's sufficient for the project.
        switch "\(T.self)" {
        case "\(GameService.self)":
            return GameService() as? T
        default: return nil
        }
    }
}
