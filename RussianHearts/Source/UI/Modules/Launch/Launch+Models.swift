//
//  Launch+Models.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import Foundation

///------

enum Launch {
    enum ModuleError: Error, Equatable {
        case failed
        case noSavedGamesFound
    }
    
    enum UIEvent: Equatable {
        case didAppear
        case didFinishLoadingData
        case didReceiveDataLoadingError
    }
    
    enum UIRoute: Equatable, Codable {
        case toMainMenu(entity: GameEntity? = nil)
    }
}

///------

extension Launch {
    struct UseCases: Model {

        // MARK: - Properties

        let id: UUID
        let loadSavedData: CodingContainer? // With type any LoadSavedDataUseCase
        let getActiveLaunchState: CodingContainer? // With type any GetActiveLaunchStateUseCase

        // MARK: - Lifecycle

        internal init(with base: Launch.UseCases?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: Launch.UseCases? = nil,
            id: UUID? = nil,
            loadSavedData: (any LoadSavedDataUseCase)? = nil,
            getActiveLaunchState: (any GetActiveLaunchStateUseCase)? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.loadSavedData = CodingContainer(loadSavedData) ?? base?.loadSavedData
            self.getActiveLaunchState = CodingContainer(getActiveLaunchState) ?? base?.getActiveLaunchState
        }

        // MARK: - Conformance: Model

        func validate() throws -> Launch.UseCases {
            guard loadSavedData != nil, getActiveLaunchState != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == Launch.UseCases {
    func with(loadSavedData: any LoadSavedDataUseCase) -> GenericBuilder<Launch.UseCases> {
        let newBase = Launch.UseCases(base: base, loadSavedData: loadSavedData)
        return GenericBuilder<Launch.UseCases>(base: newBase)
    }

    func with(getActiveLaunchState: any GetActiveLaunchStateUseCase) -> GenericBuilder<Launch.UseCases> {
        let newBase = Launch.UseCases(base: base, getActiveLaunchState: getActiveLaunchState)
        return GenericBuilder<Launch.UseCases>(base: newBase)
    }
}

///------

extension Launch {
    struct State: Model {

        // MARK: - Properties

        let id: UUID
        let isLoading: Bool?
        let alerts: Launch.State.Alerts?

        // MARK: - Lifecycle

        internal init(with base: Launch.State?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: Launch.State? = nil,
            id: UUID? = nil,
            isLoading: Bool? = nil,
            alerts: Launch.State.Alerts? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.isLoading = isLoading ?? base?.isLoading ?? false
            self.alerts = alerts ?? base?.alerts
        }

        // MARK: - Conformance: Model

        func validate() throws -> Launch.State {
            guard isLoading != nil, alerts != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == Launch.State {
    func with(isLoading: Bool) -> GenericBuilder<Launch.State> {
        let newBase = Launch.State(base: base, isLoading: isLoading)
        return GenericBuilder<Launch.State>(base: newBase)
    }

    func with(alerts: Launch.State.Alerts) -> GenericBuilder<Launch.State> {
        let newBase = Launch.State(base: base, alerts: alerts)
        return GenericBuilder<Launch.State>(base: newBase)
    }
}

///------

extension Launch.State {
    struct Alerts: Model {

        // MARK: - Properties

        let id: UUID
        let isShowingErrorAlert: Bool?

        // MARK: - Lifecycle

        internal init(with base: Launch.State.Alerts?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: Launch.State.Alerts? = nil,
            id: UUID? = nil,
            isShowingErrorAlert: Bool? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.isShowingErrorAlert = isShowingErrorAlert ?? base?.isShowingErrorAlert ?? false
        }

        // MARK: - Conformance: Model

        func validate() throws -> Launch.State.Alerts {
            guard isShowingErrorAlert != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == Launch.State.Alerts {
    func with(isShowingErrorAlert: Bool) -> GenericBuilder<Launch.State.Alerts> {
        let newBase = Launch.State.Alerts(base: base, isShowingErrorAlert: isShowingErrorAlert)
        return GenericBuilder<Launch.State.Alerts>(base: newBase)
    }
}
