//
//  ServiceContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/18/23.
//

import Foundation

protocol Service {}

/// The main focal point through which services are stored and used
protocol ServiceManaging {

    // A list of available services
    var activeServices: [Service] { get set }

    // The factory through which additional services are resolved
    var factory: ServiceFactory { get set }

    func retrieveService<T>() -> T?
}

protocol ServiceFactory {

    func buildService<T>() -> T?
}
