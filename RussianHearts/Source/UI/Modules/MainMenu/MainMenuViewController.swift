//
//  MainMenuViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import UIKit

protocol MainMenuDelegate: ModuleDelegate {
    func routeToNewGameModule()

    func routeToHighScores()

    func routeToRules()

    func routeToFriends()

    func routeToSettings()
}

protocol MainMenuView: ModuleController {
    var worker: MainMenuWorker? { get set }
    var delegate: MainMenuDelegate? { get set }

    var shouldEnableContinueButton: Bool { get }
}

class MainMenuViewController:
    UIViewController,
    MainMenuView
//    MainMenuMainViewDelegate
{
//
//    // MARK: - Properties
    var module: Module = Module.MainMenu
    var shouldRelease: Bool = false
    var worker: MainMenuWorker?

    var shouldEnableContinueButton: Bool {
//        if let worker {
//            return worker.gameFound
//        }
        return false
    }

    weak var delegate: MainMenuDelegate?
//
//    // MARK: - Views
//    lazy var mainView: MainMenuMainView = {
//        let view = MainMenuMainView(moduleColor: module.color)
//        view.delegate = self
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(view)
//
//        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//
//        return view
//    }()
//
//    // MARK: - Lifecycle
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        mainView.setupViews()
//    }
//
//    // MARK: - Actions
//    func routeToNewGameModule() {
//        delegate?.routeToNewGameModule()
//    }
//    
//    func routeToGameModule() {
//        // TODO
//    }
//    
//    func routeToHighScoreModule() {
//        delegate?.routeToHighScores()
//    }
//    
//    func routeToRulesModule() {
//        delegate?.routeToRules()
//    }
//    
//    func routeToFriendsModule() {
//        delegate?.routeToFriends()
//    }
//    
//    func routeToSettingsModule() {
//        delegate?.routeToSettings()
//    }
//
//    // MARK: - Conformance: LaunchView
//
//    // MARK: - Helpers
//
}
