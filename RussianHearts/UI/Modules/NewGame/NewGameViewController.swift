//
//  NewGameViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import UIKit

// Determines how to call on required dependencies for routing
protocol NewGameDelegate: ModuleDelegate {
    func routeBack(animated: Bool)

    func routeToGameModule()
}

protocol NewGameView: ModuleController {
    var worker: NewGameWorker? { get set }
    var delegate: NewGameDelegate? { get set }

    func backButtonTapped()

    func startNewGame(with playerValues: [Int?: String?])
}

// Needs continue button
class NewGameViewController:
    UIViewController,
    NewGameView,
    NewGameMainViewDelegate
{

    // MARK: - Properties
    var module: Module = Module.NewGame
    var worker: NewGameWorker?

    weak var delegate: NewGameDelegate?

    // MARK: - Views
    lazy var mainView: NewGameMainView = {
        let view = NewGameMainView(moduleColor: module.color)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.setupViews()
    }

    // MARK: - Actions

    // MARK: - Conformance: NewGameView
    func backButtonTapped() {
        delegate?.routeBack(animated: true)
    }
    
    func startNewGame(with playerValues: [Int? : String?]) {
        Task { @MainActor in
            await worker?.startNewGame(with: playerValues)
            delegate?.routeToGameModule()
        }
    }

    // MARK: - Helpers
}
