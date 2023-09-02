////
////  ApplicationRouter.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 8/13/23.
////
//
//import UIKit
//
//class ApplicationRouter: ApplicationWireframe {
//
//    enum Module {
//        case Launch
//        case Home
//        case NewGame
//        case Game
//        case HighScore
//    }
//
//    var moduleFactory: ModuleFactory
//
//    var rootViewController: UIViewController?
//
//    init(rootViewController: UIViewController) {
//        self.moduleFactory = ModuleFactory()
//        self.rootViewController =
//    }
//
//    func route(to module: Module) {
//        switch module {
//        case .Launch:
//            let module: LaunchViewController? = moduleFactory.resolve()
//            rootViewController?.present(module, animated: true)
//        default: break
//        }
//    }
//}
