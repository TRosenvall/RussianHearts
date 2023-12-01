//
//  FriendsViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/21/23.
//

import UIKit

// Determines how to call on required dependencies for routing
protocol FriendsDelegate: ModuleDelegate {
    func routeBackToMainMenu(from module: any ModuleController)
}

protocol FriendsView: ModuleController {
    var delegate: FriendsDelegate? { get set }
    var worker: FriendsWorker? { get set }
}

// Needs continue button
class FriendsViewController:
    UIViewController,
    FriendsView,
    FriendsMainViewDelegate
{

    // MARK: - Properties
    var module: Module = Module.Friends
    var worker: FriendsWorker?

    weak var delegate: FriendsDelegate?

    // MARK: - Views
    lazy var mainView: FriendsMainView = {
        let view = FriendsMainView(moduleColor: module.color)
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
        delegate?.routeBackToMainMenu(from: self)
    }

    // MARK: - Helpers
}
