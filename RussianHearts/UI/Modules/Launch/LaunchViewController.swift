//
//  LaunchViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 8/17/23.
//

import UIKit

class LaunchViewController: UIViewController, LaunchView {

    // MARK: - Properties
    var id: UUID = UUID()
    var presenter: LaunchPresenting?

    // MARK: - Views
    lazy var activityIndicator = UIActivityIndicatorView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.launchApp()
    }

    // MARK: - Conformance: LaunchView

    // MARK: - Helper
    func setupViews() {
        // View
        self.view.backgroundColor = .white

        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        activityIndicator.startAnimating()
    }
}
