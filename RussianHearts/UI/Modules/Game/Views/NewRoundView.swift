//
//  NewRoundView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 9/10/23.
//

import UIKit

protocol NewRoundViewDelegate {
    func getActivePlayer() -> PlayerModel?

    func newRoundContinueButtonTapped()
}

class NewRoundView: UIView {

    // MARK: - Properties
    var delegate: NewRoundViewDelegate?

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
    // Views
    lazy var setBidView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        return view
    }()

    lazy var newTurnView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)

        return view
    }()

    // Labels
    lazy var bidLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(label)

        return label
    }()

    lazy var bidAmountLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(label)

        return label
    }()
    
    // Buttons
    lazy var setBidButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(button)

        button.addTarget(self,
                         action: #selector(setBidButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var lowerBidAmountButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(button)

        button.addTarget(self,
                         action: #selector(lowerBidAmountButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    lazy var raiseBidAmountButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        setBidView.addSubview(button)

        button.addTarget(self,
                         action: #selector(raiseBidAmountButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // Labels
    lazy var playerNameLabel: UILabel = {
        let label = UILabel()

        label.translatesAutoresizingMaskIntoConstraints = false
        newTurnView.addSubview(label)

        return label
    }()
    
    // Buttons
    lazy var newRoundContinueButton: UIButton = {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        newTurnView.addSubview(button)

        button.addTarget(self,
                         action: #selector(newRoundContinueButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    init(delegate: NewRoundViewDelegate,
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
    @objc func setBidButtonTapped() {
        delegate?.newRoundContinueButtonTapped()
    }

    @objc func newRoundContinueButtonTapped() {
        newTurnView.removeFromSuperview()
        setBidView.alpha = 1
        layoutIfNeeded()
    }

    @objc func lowerBidAmountButtonTapped() {
        newTurnView.removeFromSuperview()
        setBidView.alpha = 1
        layoutIfNeeded()
    }

    @objc func raiseBidAmountButtonTapped() {
        newTurnView.removeFromSuperview()
        setBidView.alpha = 1
        layoutIfNeeded()
    }

    // MARK: - Helpers
    func setupViews() {
        // Self
        self.backgroundColor = .clear

        // Set Bid View
        setBidView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        setBidView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        setBidView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        setBidView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        setBidView.backgroundColor = .clear
        setBidView.alpha = 0

        // New Turn View
        newTurnView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        newTurnView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        newTurnView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        newTurnView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        newTurnView.backgroundColor = .clear

        // Bid Label
        bidLabel.topAnchor.constraint(equalTo: setBidView.topAnchor,
                                             constant: 22).isActive = true
        bidLabel.leadingAnchor.constraint(equalTo: setBidView.leadingAnchor,
                                                 constant: 8).isActive = true
        bidLabel.trailingAnchor.constraint(equalTo: setBidView.trailingAnchor,
                                                  constant: -8).isActive = true
        bidLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        bidLabel.textColor = moduleColor
        bidLabel.text = "Set Bid"
        bidLabel.textAlignment = .center

        // Bid Amount Label
        bidAmountLabel.topAnchor.constraint(equalTo: bidLabel.bottomAnchor,
                                            constant: 8).isActive = true
        bidAmountLabel.centerXAnchor.constraint(equalTo: setBidView.centerXAnchor).isActive = true
        bidAmountLabel.widthAnchor.constraint(equalToConstant: 22).isActive = true
        bidAmountLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        bidAmountLabel.textAlignment = .center
        bidAmountLabel.text = "\(0)"

        // Lower Bid Amount Button
        lowerBidAmountButton.topAnchor.constraint(equalTo: bidAmountLabel.topAnchor).isActive = true
        lowerBidAmountButton.leadingAnchor.constraint(equalTo: setBidView.leadingAnchor,
                                                      constant: 22).isActive = true
        lowerBidAmountButton.trailingAnchor.constraint(equalTo: bidAmountLabel.leadingAnchor,
                                                       constant: 8).isActive = true
        lowerBidAmountButton.bottomAnchor.constraint(equalTo: bidAmountLabel.bottomAnchor).isActive = true
        lowerBidAmountButton.setTitle("<", for: .normal)

        // Raise Bid Amount Button
        raiseBidAmountButton.topAnchor.constraint(equalTo: bidAmountLabel.topAnchor).isActive = true
        raiseBidAmountButton.leadingAnchor.constraint(equalTo: bidAmountLabel.trailingAnchor,
                                                      constant: 8).isActive = true
        raiseBidAmountButton.trailingAnchor.constraint(equalTo: setBidView.trailingAnchor,
                                                       constant: 22).isActive = true
        raiseBidAmountButton.bottomAnchor.constraint(equalTo: bidAmountLabel.bottomAnchor).isActive = true
        raiseBidAmountButton.setTitle(">", for: .normal)

        // Set Bid Button
        setBidButton.bottomAnchor.constraint(equalTo: setBidView.bottomAnchor,
                                                      constant: -22).isActive = true
        setBidButton.leadingAnchor.constraint(equalTo: setBidView.leadingAnchor,
                                                       constant: 22).isActive = true
        setBidButton.trailingAnchor.constraint(equalTo: setBidView.trailingAnchor,
                                                        constant: -22).isActive = true
        setBidButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        setBidButton.setTitle("Set Bid", for: .normal)
        setBidButton.setTitleColor(moduleColor, for: .normal)
        setBidButton.layer.borderColor = moduleColor.cgColor
        setBidButton.layer.borderWidth = 2
        setBidButton.layer.cornerRadius = 22

        // Player Name Label
        playerNameLabel.topAnchor.constraint(equalTo: newTurnView.topAnchor,
                                             constant: 22).isActive = true
        playerNameLabel.leadingAnchor.constraint(equalTo: newTurnView.leadingAnchor,
                                                 constant: 8).isActive = true
        playerNameLabel.trailingAnchor.constraint(equalTo: newTurnView.trailingAnchor,
                                                  constant: -8).isActive = true
        playerNameLabel.heightAnchor.constraint(equalToConstant: 33).isActive = true
        playerNameLabel.textColor = moduleColor
        playerNameLabel.text = delegate?.getActivePlayer()?.name
        playerNameLabel.textAlignment = .center

        // New Turn Continue Button
        newRoundContinueButton.bottomAnchor.constraint(equalTo: newTurnView.bottomAnchor,
                                                      constant: -22).isActive = true
        newRoundContinueButton.leadingAnchor.constraint(equalTo: newTurnView.leadingAnchor,
                                                       constant: 22).isActive = true
        newRoundContinueButton.trailingAnchor.constraint(equalTo: newTurnView.trailingAnchor,
                                                        constant: -22).isActive = true
        newRoundContinueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        newRoundContinueButton.setTitle("New Round", for: .normal)
        newRoundContinueButton.setTitleColor(moduleColor, for: .normal)
        newRoundContinueButton.layer.borderColor = moduleColor.cgColor
        newRoundContinueButton.layer.borderWidth = 2
        newRoundContinueButton.layer.cornerRadius = 22
    }
}
