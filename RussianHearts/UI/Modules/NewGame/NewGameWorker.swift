//
//  NewGameWorker.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

// Called on by presenter to do peices of work
protocol NewGameWorker: ModuleWorker {
    func startNewGame(with playerValues: [Int?: PlayerOptions?]) async
}

class NewGameWorkerImpl: NewGameWorker {

    // MARK: - Properties
    var serviceManager: ServiceManaging

    // MARK: - Lifecycle
    init(serviceManager: ServiceManaging = ServiceManager.shared) {
        self.serviceManager = serviceManager
    }

    // MARK: - Conformance: NewGameInput
    func startNewGame(with playerValues: [Int?: PlayerOptions?]) async {
        guard let gameService: GameService = serviceManager.retrieveService()
        else {
            print("Nonfatal Error")
            print("Unable to retreive the Game Service")
            return
        }

        var players: [PlayerModel] {
            var players: [PlayerModel] = []

            for value in playerValues {
                if let playerOptions = value.value,
                   let playerKey = value.key {
                    let name = playerOptions.name
                    let isHuman = playerOptions.isHuman
                    let player = PlayerModel(name: name,
                                             id: playerKey,
                                             isHuman: isHuman)
                    players.append(player)
                }
            }

            return players
        }
        let sortedPlayers = players.sorted { $0.id < $1.id }

        gameService.newGame(with: sortedPlayers)
    }

    // MARK: - Helpers
}
