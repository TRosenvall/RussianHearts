//
//  LaunchTransformer.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 1/30/24.
//

import Foundation

struct LaunchTransformer: Codable {

    // MARK: - Lifecycle

    init() { Logger.default.log("Initializing Launch Transformer") }

    // MARK: - Transformers

//    func transform(
//        completion: @escaping ((Launch.State) -> Void),
//        errorCompletion: ((Error) -> Void)? = nil
//    ) -> ((UseCaseResultType) -> Void) {
//        Logger.default.log("Transforming Use Case Result To Launch State")
//
//        return { result in
//            if let result = result as? GetActiveLaunchStateUseCaseResult {
//                switch result {
//                case .success(let state): completion(state)
//                case .error(let error):
//                    guard let errorCompletion else { return }
//                    errorCompletion(error)
//                }
//            }
//        }
//    }
}
