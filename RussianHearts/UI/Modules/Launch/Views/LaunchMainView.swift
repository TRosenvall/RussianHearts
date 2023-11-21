//
//  LaunchMainView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 11/18/23.
//

import UIKit

protocol LaunchMainViewDelegate: AnyObject {}

class LaunchMainView: UIView, MainView {

    // MARK: - Properties
    weak var delegate: LaunchMainViewDelegate?

    // MARK: - Views
    lazy var activityIndicator = UIActivityIndicatorView()

    // MARK: - Lifecycle
    init() {
        super.init(frame: CGRect())
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    func stopAnimatingActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    // MARK: - Conformance: MainView
    func setupViews() {
        // View
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white

        // Activity Indicator
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        activityIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        activityIndicator.startAnimating()
    }

    // MARK: - Helpers
}
