////
////  BackButtonTappedView.swift
////  RussianHearts
////
////  Created by Timothy Rosenvall on 9/10/23.
////
//
//import UIKit
//
//protocol BackButtonTappedViewDelegate {
//    func backButtonTapped()
//
//    func cancelButtonTapped()
//
//    func removeGame()
//}
//
//class BackButtonTappedView: UIView {
//    
//    // MARK: - Properties
//    var delegate: BackButtonTappedViewDelegate?
//
//    // Default color is black but should be updated immediately after initialization
//    private var _moduleColor: UIColor = .black
//    var moduleColor: UIColor {
//        get {
//            return _moduleColor
//        }
//        set {
//            _moduleColor = newValue
//            setupViews()
//        }
//    }
//
//    // MARK: - Views
//    // Labels
//    lazy var backLabel: UILabel = {
//        let label = UILabel()
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(label)
//
//        return label
//    }()
//    
//    // Buttons
//    lazy var backButton: UIButton = {
//        let button = UIButton(type: .system)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(button)
//
//        button.addTarget(self,
//                         action: #selector(backButtonTapped),
//                         for: .touchUpInside)
//        return button
//    }()
//
//    lazy var cancelButton: UIButton = {
//        let button = UIButton(type: .system)
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(button)
//
//        button.addTarget(self,
//                         action: #selector(cancelButtonTapped),
//                         for: .touchUpInside)
//        return button
//    }()
//
//    // MARK: - Lifecycle
//    init(delegate: BackButtonTappedViewDelegate,
//         moduleColor: UIColor) {
//        super.init(frame: CGRect())
//        self.delegate = delegate
//        self.moduleColor = moduleColor
//
//        self.translatesAutoresizingMaskIntoConstraints = false
//
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Actions
//    @objc func backButtonTapped() {
//        delegate?.removeGame()
//        delegate?.backButtonTapped()
//    }
//
//    @objc func cancelButtonTapped() {
//        delegate?.cancelButtonTapped()
//    }
//
//    // MARK: - Helpers
//    func setupViews() {
//        // Self
//        self.backgroundColor = .clear
//
//        // Back Label
//        backLabel.topAnchor.constraint(equalTo: self.topAnchor,
//                                             constant: 22).isActive = true
//        backLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
//                                                 constant: 8).isActive = true
//        backLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
//                                                  constant: -8).isActive = true
//        backLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
//        backLabel.textColor = moduleColor
//        backLabel.text = "Quit Current Game?"
//        backLabel.textAlignment = .center
//
//        // Back Button
//        backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
//                                                      constant: -22).isActive = true
//        backButton.widthAnchor.constraint(equalTo: self.widthAnchor,
//                                          multiplier: 0.4).isActive = true
//        backButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
//                                             constant: -22).isActive = true
//        backButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        backButton.setTitle("Quit", for: .normal)
//        backButton.setTitleColor(moduleColor, for: .normal)
//        backButton.layer.borderColor = moduleColor.cgColor
//        backButton.layer.borderWidth = 2
//        backButton.layer.cornerRadius = 22
//
//        // Cancel Button
//        cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
//                                                      constant: -22).isActive = true
//        cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,
//                                                       constant: 22).isActive = true
//        cancelButton.widthAnchor.constraint(equalTo: self.widthAnchor,
//                                            multiplier: 0.4).isActive = true
//        cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.setTitleColor(moduleColor, for: .normal)
//        cancelButton.layer.borderColor = moduleColor.cgColor
//        cancelButton.layer.borderWidth = 2
//        cancelButton.layer.cornerRadius = 22
//    }
//}
