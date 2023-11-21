//
//  LaunchViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/17/23.
//

import UIKit

// Determines how to call on required dependencies for routing
protocol LaunchDelegate: ModuleDelegate {
    func routeToMainApplication()
}

protocol LaunchView: ModuleController {
    var worker: LaunchWorker? { get set }
    var delegate: LaunchDelegate? { get set }

    func launchApp()
}

class LaunchViewController:
    UIViewController,
    LaunchView,
    LaunchMainViewDelegate
{
    // MARK: - Properties
    var module: Module = Module.Launch
    var worker: LaunchWorker?

    weak var delegate: LaunchDelegate?

    // MARK: - Views
    lazy var mainView: LaunchMainView = {
        let view = LaunchMainView()
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        launchApp()
    }

    // MARK: - Conformance: LaunchView
    func launchApp() {
//        Task { @MainActor in 
//            do {
//                try await worker?.loadData(from: .local)
//            } catch {
//                fatalError("Data Not Loaded")
//            }
//        }
        mainView.stopAnimatingActivityIndicator()
        delegate?.routeToMainApplication()
    }

    // MARK: - Helper
}
