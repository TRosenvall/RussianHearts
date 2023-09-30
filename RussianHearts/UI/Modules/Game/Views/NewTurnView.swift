//
//  NewTurnView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/10/23.
//

import UIKit

protocol NewTurnViewDelegate {
    func getActivePlayer() -> PlayerModel?

    func newTurnContinueButtonTapped()
}

class NewTurnView: UIView {
    
    // MARK: - Properties
    var delegate: NewTurnViewDelegate?
    
    // Default color is black but should be updated immediately after initialization
    private var _moduleColor: UIColor = .black
    var moduleColor: UIColor {
        get {
            return _moduleColor
        }
        set {
            _moduleColor = newValue
            setupViews()
        }
    }

    // MARK: - Views
    // Labels
    lazy var playerNameLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        return label
    }()
    
    // Buttons
    lazy var newTurnContinueButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)

        button.addTarget(self,
                         action: #selector(newTurnContinueButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    init(delegate: NewTurnViewDelegate,
         moduleColor: UIColor) {
        super.init(frame: CGRect())
        self.delegate = delegate
        self.moduleColor = moduleColor

        self.translatesAutoresizingMaskIntoConstraints = false

        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func newTurnContinueButtonTapped() {
        delegate?.newTurnContinueButtonTapped()
    }

    // MARK: - Helpers
    func setupViews() {
        // Self
        self.backgroundColor = .clear

        // Player Name Label
        playerNameLabel.topAnchor.constraint(equalTo: self.topAnchor,
                                             constant: 22).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                 constant: 8).isActive = true
        playerNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: -8).isActive = true
        playerNameLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        playerNameLabel.textColor = moduleColor
        playerNameLabel.text = delegate?.getActivePlayer()?.name
        playerNameLabel.textAlignment = .center

        // New Turn Continue Button
        newTurnContinueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,
                                                      constant: -22).isActive = true
        newTurnContinueButton.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                       constant: 22).isActive = true
        newTurnContinueButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                        constant: -22).isActive = true
        newTurnContinueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        newTurnContinueButton.setTitle("New Turn", for: .normal)
        newTurnContinueButton.setTitleColor(moduleColor, for: .normal)
        newTurnContinueButton.layer.borderColor = moduleColor.cgColor
        newTurnContinueButton.layer.borderWidth = 2
        newTurnContinueButton.layer.cornerRadius = 22
    }
}
