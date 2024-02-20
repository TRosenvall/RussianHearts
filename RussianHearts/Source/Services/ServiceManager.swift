//
//  ServiceManager.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/18/23.
//

import Foundation

class ServiceManager: ServiceManaging {

    // MARK: - Properties
    static var shared: ServiceManaging = ServiceManager()

    var factory: ServiceFactory

    var activeServices: [any Service]

    // MARK: - Lifecycle
    init(factory: ServiceFactory = ServiceFactoryImpl(),
         activeServices: [any Service] = []) {
        self.factory = factory
        self.activeServices = activeServices
    }

    // MARK: - Conformance: ServiceManaging
    func retrieveService<T>() -> T? {
        for service in activeServices where service is T {
            return service as? T
        }
        let service: T? = factory.buildService()
        guard let resolvedService = service as? any Service
        else { return nil }
        self.activeServices.append(resolvedService)
        return service
    }
}
