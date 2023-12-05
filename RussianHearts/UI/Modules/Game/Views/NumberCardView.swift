//
//  NumberCardView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/19/23.
//

import UIKit

class NumberCardView: CardView {

    // MARK: - Properties
    let borderWidth: CGFloat = 3
    var wasDisabled: Bool = false
    var cardColor: UIColor {
        guard let card = card as? NumberCard
        else { fatalError("Card Type Misaligned") }
        if isUpsideDown {
            return .darkGray
        }
        return card.suit.transformToColor()
    }

    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            backgroundBorderView.layer.cornerRadius = newValue
        }
    }

    var cardText: String = "Placeholder"
    override var isUpsideDown: Bool {
        get {
            return _isUpsideDown
        }
        set {
            guard let card = card as? NumberCard
            else { fatalError("Card Type Misaligned") }

            _isUpsideDown = newValue
            if _isUpsideDown {
                cardText = "Card Back"
            } else {
                cardText = "\(card.value.rawValue)"
            }
            setupViews()
        }
    }

    var cardSuit: CardSuit {
        guard let card = card as? NumberCard
        else { fatalError("Card Type Misaligned") }

        return card.suit
    }

    var cardValue: CardValues {
        guard let card = card as? NumberCard
        else { fatalError("Card Type Misaligned") }

        return card.value
    }

    // MARK: - Views
    // Views
    lazy var backgroundBorderView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        
        return view
    }()

    lazy var backgroundColorView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        backgroundBorderView.addSubview(view)
        
        return view
    }()

    lazy var disabledView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    // Labels
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        return label
    }()

    // Buttons
    lazy var cardTappedButton: UIButton = {
        let button = UIButton()

        button.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(button)

        button.addTarget(self,
                         action: #selector(cardTappedButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    init(card: NumberCard) {
        super.init(card: card)

        self.translatesAutoresizingMaskIntoConstraints = false

        _isUpsideDown = true
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func cardTappedButtonTapped() {
        delegate?.tapped(self)
    }

    // MARK: - Helpers
    func setupViews() {
        // View
        backgroundColor = .white

        // Background Color View
        backgroundBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        backgroundBorderView.layer.borderColor = cardColor.cgColor
        backgroundBorderView.layer.borderWidth = borderWidth
        backgroundBorderView.layer.cornerRadius = cornerRadius

        // Background Color View
        backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        backgroundColorView.backgroundColor = cardColor
        backgroundColorView.alpha = 0.05

        // Value Label
        valueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
        valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22).isActive = true
        valueLabel.textAlignment = .center
        valueLabel.textColor = cardColor
        valueLabel.text = cardText
        valueLabel.font = valueLabel.font.withSize(100)
        valueLabel.minimumScaleFactor = 0.2
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.numberOfLines = 0

        cardTappedButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardTappedButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        cardTappedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        cardTappedButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    func addDisabledView() {
        isDisabled = true
        self.addSubview(disabledView)
        disabledView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        disabledView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        disabledView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        disabledView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        disabledView.backgroundColor = .darkGray
        disabledView.alpha = 0.66
    }

    func removeDisabledView() {
        isDisabled = false
        disabledView.removeFromSuperview()
    }
}
