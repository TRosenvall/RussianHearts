//
//  RulesViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/21/23.
//

import UIKit

// Determines how to call on required dependencies for routing
protocol RulesDelegate: ModuleDelegate {
    func routeBackToMainMenu(from module: any ModuleController)
}

protocol RulesView: ModuleController {
    var delegate: RulesDelegate? { get set }
    var worker: RulesWorker? { get set }
}

// Needs continue button
class RulesViewController:
    UIViewController,
    RulesView
//    RulesMainViewDelegate
{

    // MARK: - Properties
    var module: Module = Module.Tutorial
    var shouldRelease: Bool = false
    var worker: RulesWorker?

    weak var delegate: RulesDelegate?
//
//    // MARK: - Views
//    lazy var mainView: RulesMainView = {
//        let view = RulesMainView(moduleColor: module.color)
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
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        mainView.setupViews()
//    }
//
//    // MARK: - Actions
//    func backButtonTapped() {
//        delegate?.routeBackToMainMenu(from: self)
//    }
//
//    // MARK: - Helpers
}
