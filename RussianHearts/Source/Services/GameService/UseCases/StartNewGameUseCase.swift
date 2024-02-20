//
//  StartNewGameUseCase.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 12/24/23.
//
//
//import Foundation
//
//protocol StartNewGameDelegate: AnyObject {}
//
//enum StartNewGameUseCaseResult {
//    case success
//}
//
//struct StartNewGame: GameServiceUseCase {
//
//    typealias Result = StartNewGameUseCaseResult
//    
//    static var useCaseType: GameService.UseCase { .startNewGame }
//
//    var params: Any? = nil
//
//    func setParams(_ params: Any?) -> StartNewGame {
//        return self
//    }
//
//    func execute<T>(params: Any?) async throws -> T? {
//        return nil
//    }
//
//    weak var delegate: StartNewGameDelegate?
//
//    init(delegate: StartNewGameDelegate? = nil) {
//        self.delegate = delegate
//    }
//
//    func execute() async {
//        print("Execute Start New Game Use Case")
//
//        // Get Player Info
//
//        // Create Players
//
//        // Setup Starting Tricks
//
//        // Setup Starting Rounds
//
//        // Deal Cards To Players For New Round
//
//        // Get Trump Card
//
//        // Setup Starting Game State
//
//        // Create New Game Entity With New State
//
//        // Save New Game Entity
//    }
//}
