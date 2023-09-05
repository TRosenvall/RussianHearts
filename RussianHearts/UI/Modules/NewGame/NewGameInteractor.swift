//
//  NewGameInteractor.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/27/23.
//

import Foundation

class NewGameInteractor: NewGameInput {

    // MARK: - Properties
    var output: NewGameOutput?
    var serviceManager: ServiceManaging

    // MARK: - Lifecycle
    init(serviceManager: ServiceManaging = ServiceManager.shared) {
        self.serviceManager = serviceManager
    }

    // MARK: - Conformance: NewGameInput
    func startNewGame(with playerValues: [Int?: String?]) {
        guard let gameService: GameService = serviceManager.retrieveService()
        else {
            print("Nonfatal Error")
            print("Unable to retreive the Game Service")
            return
        }

        var players: [PlayerModel] {
            var players: [PlayerModel] = []

            for value in playerValues {
                if let playerValue = value.value,
                   let playerKey = value.key {
                    let player = PlayerModel(name: playerValue, id: playerKey)
                    players.append(player)
                }
            }

            return players
        }

        gameService.newGame(with: players)
        output?.routeToGameModule()
    }

    // MARK: - Helpers
}
