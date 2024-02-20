////
////  EndRoundUseCase.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 12/24/23.
////
//
//import Foundation
//
//protocol EndRoundDelegate: AnyObject {}
//
//enum EndRoundResult {
//    case success
//}
//
//struct EndRound: GameServiceUseCase {
//
//    typealias Result = EndRoundResult
//    
//    static var useCaseType: GameService.UseCase { .endRound }
//
//    var params: Any? = nil
//
//    func setParams(_ params: Any?) -> EndRound {
//        // TODO
//        return self
//    }
//
//    weak var delegate: EndRoundDelegate?
//
//    init(delegate: EndRoundDelegate? = nil) {
//        self.delegate = delegate
//    }
//
//    func execute<T>(params: Any?) async throws -> T? {
//        print("Execute End Round Use Case")
//        return nil
//
//        // Pull Latest Game Entity
//
//        // Check If Round End
//
//        // Score Round
//
//        // Shuffle Discard Pile Into Draw Pile
//
//        // Deal Cards To Players For New Round
//
//        // Get Trump Card
//
//        // Create New Game Entity With New State
//
//        // Save New Game Entity
//    }
//}
