//
//  NewGameTransformer.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 3/12/24.
//

import Foundation

struct NewGameTransformer: Codable {

    // MARK: - Lifecycle

    init() { Logger.default.log("Initializing New Game Transformer") }

    // MARK: - Transformers

    func transformToEntity(_ state: NewGame.State) throws -> GameEntity {
        Logger.default.log("Building Initial Game Entity")

        let players: [Player] = state.players.compactMap { player in
            do {
                if !player.name.isEmpty {
                    return try Player.Builder
                        .with(name: player.name)
                        .isHuman(player.isHuman)
                        .hasPlayed(false)
                        .build()
                } else {
                    return nil
                }
            } catch {
                Logger.default.logFatal("Unable to initialize player, error: \(error)")
            }
        }

        let deck = DeckController()

        let cardsPerRound = [7, 5, 3, 1, 2, 4, 6]

        let rounds: [Round] = cardsPerRound.enumerated().map { (cardsForRound, index) in
            do {
                let round = try Round.Builder
                    .with(numberOfCardsToPlay: cardsForRound)
                    .with(roundName: "Round: \(index + 1)")
                    .with(phaseState: index == 0 ? .active : .inactive)
                    .build()
                return round
            } catch {
                Logger.default.logFatal("Unable to initialize round, error: \(error)")
            }
        }

        guard let firstRound = rounds.first
        else { Logger.default.logFatal("Error in round initialization: Empty Rounds Array") }

        let state = try GameState.Builder
            .with(rounds: rounds)
            .with(players: players)
            .with(activeRound: firstRound)
            .with(phaseState: .active)
            .with(deck: deck)
            .isEndOfGame(false)
            .build()

        do {
            let entity = try GameEntity.Builder
                .with(gameStates: [state])
                .with(completionState: .active)
                .build()
            return entity
        } catch {
            Logger.default.logFatal("Unable to initialize Game Entity, error: \(error)")
        }
    }
}
