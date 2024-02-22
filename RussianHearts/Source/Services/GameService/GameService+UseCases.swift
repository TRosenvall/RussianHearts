//
//  GameService+UseCases.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 2/15/24.
//

import Foundation

extension GameService {

    enum UseCaseType {
        case retrieveGameState
        case endTurn
        case endTrick
        case endRound
        case startNewGame
        case loadGame
    }

    struct UseCase: Model {

        // MARK: - Properties

        typealias AssociatedEntity = GameEntity

        let id: UUID
        let retrieveGameState: CodingContainer? // With type RetrieveGameStateUseCase

        // MARK: - LifeCycle

        internal init(with base: GameService.UseCase?, id: UUID?) {
            self.init(base: base, id: id)
        }

        fileprivate init(
            base: GameService.UseCase? = nil,
            id: UUID? = nil,
            retrieveGameState: (any RetrieveGameStateUseCase)? = nil
        ) {
            self.id = id ?? base?.id ?? UUID()
            self.retrieveGameState = CodingContainer(retrieveGameState) ?? base?.retrieveGameState
        }

        // MARK: - Conformance: Model

        func validate() throws -> GameService.UseCase {
            guard retrieveGameState != nil
            else { throw ModelError.requiredModelPropertiesNotSet(onType: Self.self) }

            return self
        }
    }
}

extension GenericBuilder where T == GameService.UseCase {
    func with(retrieveGameState: any RetrieveGameStateUseCase) -> GenericBuilder<GameService.UseCase> {
        let newBase = GameService.UseCase(base: base, retrieveGameState: retrieveGameState)
        return GenericBuilder<GameService.UseCase>(base: newBase)
    }
}

