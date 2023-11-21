//
//  HighscoresViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/19/23.
//

import UIKit

// Determines how to call on required dependencies for routing
protocol HighscoresDelegate: ModuleDelegate {
    func routeToMainMenu()
}

protocol HighscoresView: ModuleController {
    var delegate: HighscoresDelegate? { get set }
    var worker: HighscoresWorker? { get set }
}

// Needs continue button
class HighscoresViewController:
    UIViewController,
    HighscoresView,
    HighscoresMainViewDelegate
{

    // MARK: - Properties
    var module: Module = Module.Highscore
    var worker: HighscoresWorker?

    weak var delegate: HighscoresDelegate?

    // MARK: - Views
    lazy var mainView: HighscoresMainView = {
        let view = HighscoresMainView(moduleColor: module.color)
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
    func backButtonTapped() {
        delegate?.routeToMainMenu()
    }

    // MARK: - Helpers
}
