//
//  MainMenuViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/24/23.
//

import UIKit

protocol MainMenuDelegate: ModuleDelegate {
    func routeToNewGameModule()

    func routeToHighscoresModule()
}

protocol MainMenuView: ModuleController {
    var worker: MainMenuWorker? { get set }
    var delegate: MainMenuDelegate? { get set }

    var shouldEnableContinueButton: Bool { get }

    /// Routes to the new game module
    func routeToNewGameModule()

    /// Routes to the game module with a saved game
    func routeToGameModule()

    /// Routes to the high score module
    func routeToHighScoreModule()

    /// Routes to the rules modules
    func routeToRulesModule()

    /// Routes to the friend module
    func routeToFriendModule()

    /// Routes to the settings module
    func routeToSettingsModule()
}

class MainMenuViewController:
    UIViewController,
    MainMenuView,
    MainMenuMainViewDelegate
{

    // MARK: - Properties
    var module: Module = Module.MainMenu
    var worker: MainMenuWorker?

    var shouldEnableContinueButton: Bool {
        if let worker {
            return worker.gameFound
        }
        return false
    }

    weak var delegate: MainMenuDelegate?

    // MARK: - Views
    lazy var mainView: MainMenuMainView = {
        let view = MainMenuMainView(moduleColor: module.color)
        view.delegate = self

        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)

        view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        mainView.setupViews()
    }

    // MARK: - Actions
    func routeToNewGameModule() {
        delegate?.routeToNewGameModule()
    }
    
    func routeToGameModule() {
        // TODO
    }
    
    func routeToHighScoreModule() {
        delegate?.routeToHighscoresModule()
    }
    
    func routeToRulesModule() {
        // TODO
    }
    
    func routeToFriendModule() {
        // TODO
    }
    
    func routeToSettingsModule() {
        // TODO
    }

    // MARK: - Conformance: LaunchView

    // MARK: - Helpers

}
