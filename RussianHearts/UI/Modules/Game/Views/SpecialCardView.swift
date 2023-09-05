//
//  SpecialCardView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/19/23.
//

import UIKit

class SpecialCardView: CardView {

    // MARK: - Properties
    var card: SpecialCard
    let borderWidth: CGFloat = 3
    var cardColor: UIColor {
        return .darkGray
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
            _isUpsideDown = newValue
            if _isUpsideDown {
                cardText = "Card Back"
            } else {
                cardText = "\(card.name)"
            }
            setupViews()
        }
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
    init(card: SpecialCard) {
        self.card = card
        super.init(frame: CGRect())

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
        backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10).isActive = true
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
}

//class SpecialCardView: UIView {
//
//    var card: SpecialCard?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView(height: frame.height)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("Not implemented")
//    }
//
//    convenience init(card: SpecialCard, height: CGFloat) {
//        self.init(frame: .zero)
//        self.card = card
//        setupView(height: height)
//    }
//
//    func setupView(height: CGFloat) {
//        if let card {
//            self.clipsToBounds = true
//
//            // Gradient Background Color
//            let gradientView = NumberGradientView(frame: self.frame)
//            gradientView.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(gradientView)
//            gradientView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//            gradientView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
//            gradientView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//            gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//
//            // Top Left Corner
//            let topCornerImage = UIImageView(image: Assets.secondaryImage(for: card.type))
//            topCornerImage.translatesAutoresizingMaskIntoConstraints = false
//            topCornerImage.widthAnchor.constraint(equalTo: topCornerImage.heightAnchor).isActive = true
//
//            let textAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont(name: "Rothenburg Decorative", size: 33) as Any,
//                .baselineOffset: -2
//            ]
//            let topCornerTextField = UILabel()
//            topCornerTextField.clipsToBounds = false
//            topCornerTextField.attributedText = NSAttributedString(string: "The \(card.name)",
//                                                                   attributes:  textAttributes)
//
//            let topStackView: UIStackView = UIStackView()
//            topStackView.addArrangedSubview(topCornerImage)
//            topStackView.addArrangedSubview(topCornerTextField)
//
//            topStackView.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(topStackView)
//            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
//            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11).isActive = true
//            topStackView.heightAnchor.constraint(equalToConstant: 55).isActive = true
//            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11).isActive = true
//
//            // Bottom Left Corner
//            let bottomCornerImage = UIImageView(image: Assets.secondaryImage(for: card.type))
//            bottomCornerImage.translatesAutoresizingMaskIntoConstraints = false
//            bottomCornerImage.widthAnchor.constraint(equalTo: bottomCornerImage.heightAnchor).isActive = true
//
//            let bottomCornerTextField = UILabel()
//            bottomCornerTextField.clipsToBounds = false
//            bottomCornerTextField.attributedText = NSAttributedString(string: "The \(card.name)",
//                                                                      attributes:  textAttributes)
//
//            let bottomStackView: UIStackView = UIStackView()
//            bottomStackView.addArrangedSubview(bottomCornerTextField)
//            bottomStackView.addArrangedSubview(bottomCornerImage)
//
//            bottomStackView.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(bottomStackView)
//            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
//            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11).isActive = true
//            bottomStackView.heightAnchor.constraint(equalToConstant: 55).isActive = true
//            bottomStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11).isActive = true
//            bottomCornerTextField.textAlignment = .right
//
//            // Middle View
//            let iconView = UIView()
//            iconView.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(iconView)
//            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
//            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11).isActive = true
//            iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11).isActive = true
//            iconView.layer.borderWidth = 2
//            iconView.layer.borderColor = UIColor.black.cgColor
//
//            let image = UIImageView(image: card.image)
//            iconView.addSubview(image)
//            image.translatesAutoresizingMaskIntoConstraints = false
//            image.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
//            image.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
//            image.widthAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
//            image.heightAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true
//            image.alpha = 0.6
//
//            let ratio = 22/500 * height
//            self.layer.cornerRadius = ratio
//        }
//    }
//
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        setupView(height: 500)
//    }
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        setupView(height: rect.height)
//    }
//}
