//
//  ServiceContracts.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/18/23.
//

import Foundation

protocol Service: Model {}

/// The main focal point through which services are stored and used
protocol ServiceManaging {

    // A list of available services
    var activeServices: [any Service] { get set }

    // The factory through which additional services are resolved
    var factory: ServiceFactory { get set }

    func retrieveService<T>() -> T?
}

///------

protocol ServiceFactory {

    func buildService<T>() -> T?
}

///------

protocol UseCaseResultType {}

///------

protocol UseCaseOutput: Model {
    func handleUseCaseResult(_ result: any UseCaseResultType)
}

///------

enum UseCaseError: Error {
    case useCaseNotFound
}

///------

protocol UseCase: Model {

    associatedtype ResultType: UseCaseResultType

    var completion: ((ResultType) -> Void)? { get }

    init(base: Self, completion: ((ResultType) -> Void)?)

    func with(completion: ((ResultType) -> Void)?) -> Self

    func execute() async
}

extension UseCase {

    func with(completion: ((ResultType) -> Void)? = nil) -> Self {
        return .init(base: self, completion: completion)
    }
}
