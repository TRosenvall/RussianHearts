////
////  SettingsMainView.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 11/21/23.
////
//
//import UIKit
//
//protocol SettingsMainViewDelegate: AnyObject {
//    func backButtonTapped()
//}
//
//class SettingsMainView: UIView, MainView {
//
//    // MARK: - Properties
//    weak var delegate: SettingsMainViewDelegate?
//
//    var moduleColor: UIColor
//
//    // MARK: - Views
//    // Views
//    lazy var backgroundBorderView: UIView = {
//        let view = UIView()
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//        
//        return view
//    }()
//
//    lazy var backgroundColorView: UIView = {
//        let view = UIView()
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        backgroundBorderView.addSubview(view)
//        
//        return view
//    }()
//
//    lazy var navBarView: UIView = {
//        let view = UIView()
//        
//        view.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(view)
//        
//        return view
//    }()
//
//    // Labels
//    lazy var titleLabel: UILabel = {
//        let label = UILabel()
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        navBarView.addSubview(label)
//
//        return label
//    }()
//
//    // Buttons
//    lazy var backButton: UIButton = {
//        let button = UIButton(type: .system)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        navBarView.addSubview(button)
//
//        button.addTarget(self,
//                         action: #selector(backButtonTapped),
//                         for: .touchUpInside)
//        return button
//    }()
//
//    // MARK: - Lifecycle
//    init(moduleColor: UIColor) {
//        self.moduleColor = moduleColor
//        super.init(frame: CGRect())
//
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Actions
//    @objc func backButtonTapped(sender: UIButton!) {
//        delegate?.backButtonTapped()
//    }
//
//    // MARK: - Conformance: MainView
//    func setupViews() {
//        // Constants
//        let spacer: CGFloat = 22
//        let borderWidth: CGFloat = 3
//        let cornerRadius: CGFloat = self.frame.width/7
//
//        // View
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.backgroundColor = .white
//
//        // Background Color View
//        backgroundBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        backgroundBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        backgroundBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//        backgroundBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//        // Figured these numbers out by guess and check, these should probably be formalized.
//        backgroundBorderView.layer.borderColor = moduleColor.cgColor
//        backgroundBorderView.layer.borderWidth = borderWidth
//        backgroundBorderView.layer.cornerRadius = cornerRadius
//
//        // Background Color View
//        backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
//        backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
//        backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
//        backgroundColorView.backgroundColor = moduleColor
//        backgroundColorView.alpha = 0.001
//
//        // Nav Bar View
//        navBarView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
//        navBarView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        navBarView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        navBarView.heightAnchor.constraint(equalToConstant: 44).isActive = true
//
//        // Back Button
//        backButton.topAnchor.constraint(equalTo: navBarView.topAnchor).isActive = true
//        backButton.leadingAnchor.constraint(equalTo: navBarView.leadingAnchor).isActive = true
//        backButton.widthAnchor.constraint(equalToConstant: 3*spacer).isActive = true
//        backButton.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
//        backButton.setImage(UIImage(systemName: "arrow.left")?.withRenderingMode(.alwaysTemplate),
//                            for: .normal)
//        backButton.tintColor = moduleColor
//
//        // Title Label
//        titleLabel.topAnchor.constraint(equalTo: navBarView.topAnchor).isActive = true
//        titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor).isActive = true
//        titleLabel.centerXAnchor.constraint(equalTo: navBarView.centerXAnchor).isActive = true
//        titleLabel.bottomAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
//        titleLabel.text = "Settings"
//        titleLabel.textAlignment = .center
//        titleLabel.textColor = moduleColor
//    }
//
//    // MARK: - Helpers
//}
