////
////  EndTrickUseCase.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 12/24/23.
////
//
//import Foundation
//
//protocol EndTrickDelegate: AnyObject {}
//
//enum EndTrickResult {
//    case success
//}
//
//struct EndTrick: GameServiceUseCase {
//
//    typealias Result = EndTrickResult
//    
//    static var useCaseType: GameService.UseCase { .endTrick }
//
//    var params: Any? = nil
//
//    func setParams(_ params: Any?) -> EndTrick {
//        // TODO
//        return self
//    }
//
//    weak var delegate: EndTrickDelegate?
//
//    init(delegate: EndTrickDelegate? = nil) {
//        self.delegate = delegate
//    }
//
//    func execute<T>(params: Any?) async throws -> T? {
//        print("Execute End Trick Use Case")
//        return nil
//
//        // Pull Latest Game Entity
//
//        // Check If Trick End
//
//        // Collect Cards And Move To Discard Pile
//
//        // Create New Game Entity With New State
//
//        // Save New Game Entity
//    }
//}
