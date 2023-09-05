//
//  NumberCardView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/19/23.
//

import UIKit

class NumberCardView: CardView {

    // MARK: - Properties
    var card: NumberCard
    let borderWidth: CGFloat = 3
    var cardColor: UIColor {
        if isUpsideDown {
            return .darkGray
        }
        switch card.suit {
        case .crosses: return .brown
        case .crowns: return .blue
        case .sickles: return .purple
        case .swords: return .red
        }
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
                cardText = "\(card.value.rawValue)"
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
    init(card: NumberCard) {
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

//
//    convenience init(card: NumberCard, height: CGFloat) {
//        self.init(frame: .zero)
//        self.card = card
//        setupView(height: height)
//    }
//
//    func setupView(height: CGFloat) {
//        if let card {
//            self.clipsToBounds = true
//
//            let ratio = height/500
//
//            let cornerRadius = ratio * 22
//            let textHeight = ratio * 44
//            let baselineOffsetForText = ratio * -2
//
//            let smallInset = ratio * 11
//            let mediumInset = ratio * 44
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
//            let topCornerImage = UIImageView(image: card.image)
//            topCornerImage.translatesAutoresizingMaskIntoConstraints = false
//            topCornerImage.widthAnchor.constraint(equalTo: topCornerImage.heightAnchor).isActive = true
//
//            let textAttributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont(name: "Rothenburg Decorative", size: textHeight) as Any,
//                .baselineOffset: baselineOffsetForText
//            ]
//            let topCornerTextField = UILabel()
//            topCornerTextField.attributedText = NSAttributedString(string: "\(card.value.rawValue)",
//                                                                   attributes:  textAttributes)
//
//            let topStackView: UIStackView = UIStackView()
//            topStackView.addArrangedSubview(topCornerImage)
//            topStackView.addArrangedSubview(topCornerTextField)
//
//            topStackView.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(topStackView)
//            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: smallInset).isActive = true
//            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -smallInset).isActive = true
//            topStackView.heightAnchor.constraint(equalToConstant: mediumInset).isActive = true
//            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: smallInset).isActive = true
//
//            // Bottom Right Corner
//            let bottomCornerImage = UIImageView(image: card.image)
//            bottomCornerImage.translatesAutoresizingMaskIntoConstraints = false
//            bottomCornerImage.widthAnchor.constraint(equalTo: bottomCornerImage.heightAnchor).isActive = true
//
//            let bottomCornerTextField = UILabel()
//            bottomCornerTextField.attributedText = NSAttributedString(string: "\(card.value.rawValue)",
//                                                                   attributes:  textAttributes)
//            bottomCornerTextField.textAlignment = .right
//
//            let bottomStackView: UIStackView = UIStackView()
//            bottomStackView.addArrangedSubview(bottomCornerTextField)
//            bottomStackView.addArrangedSubview(bottomCornerImage)
//            bottomStackView.alignment = .trailing
//
//            bottomStackView.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(bottomStackView)
//            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -smallInset).isActive = true
//            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -smallInset).isActive = true
//            bottomStackView.heightAnchor.constraint(equalToConstant: mediumInset).isActive = true
//            bottomStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: smallInset).isActive = true
//            bottomCornerImage.heightAnchor.constraint(equalToConstant: mediumInset).isActive = true
//
//            // Middle View
//            let iconView = UIView()
//            iconView.translatesAutoresizingMaskIntoConstraints = false
//            self.addSubview(iconView)
//            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
//            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: smallInset).isActive = true
//            iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -smallInset).isActive = true
//
//            setupCardFor(number: card.value.rawValue, onView: iconView, height: height)
//
//            self.layer.cornerRadius = cornerRadius
//        }
//    }
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        setupView(height: rect.height)
//    }
//
//    override func layoutIfNeeded() {
//        super.layoutIfNeeded()
//        setupView(height: frame.height)
//    }
//
//    // MARK: - Helper functions
//
//    func setupCardFor(number: Int, onView thisView: UIView, height: CGFloat) {
//        switch number {
//        case 1:
//            // 1 Card
//            placeImageAt(CGPoint(x: 0, y: 0), on: thisView, height: height)
//        case 2:
//            // 2 Card
//            placeImageAt(CGPoint(x: 0, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -0.5), on: thisView, height: height)
//        case 3:
//            // 3 Card
//            placeImageAt(CGPoint(x: 0, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0.5, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -0.5, y: -0.5), on: thisView, height: height)
//        case 4:
//            // 4 Card
//            placeImageAt(CGPoint(x: 0.5, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0.5, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -0.5, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -0.5, y: -0.5), on: thisView, height: height)
//        case 5:
//            // 5 Card
//            placeImageAt(CGPoint(x: -1, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 0), on: thisView, height: height)
//        case 6:
//            // 6 Card
//            placeImageAt(CGPoint(x: -0.5, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -0.5, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -0.5, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0.5, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0.5, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0.5, y: 1), on: thisView, height: height)
//        case 7:
//            // 7 Card
//            placeImageAt(CGPoint(x: -1, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 0.5), on: thisView, height: height)
//        case 8:
//            // 8 Card
//            placeImageAt(CGPoint(x: -1, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 1), on: thisView, height: height)
//        case 9:
//            // 9 Card
//            placeImageAt(CGPoint(x: -1, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 1), on: thisView, height: height)
//        case 10:
//            // 10 Card
//            placeImageAt(CGPoint(x: -1, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 1), on: thisView, height: height)
//        case 11:
//            // 11 Card
//            placeImageAt(CGPoint(x: -1, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 0), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 1.5), on: thisView, height: height)
//        case 12:
//            // 12 Card
//            placeImageAt(CGPoint(x: -1, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 1.5), on: thisView, height: height)
//        case 13:
//            // 13 Card
//            placeImageAt(CGPoint(x: -1.5, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1.5, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -0.5, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0.5, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1.5, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1.5, y: 0.5), on: thisView, height: height)
//        case 14:
//            // 14 Card
//            placeImageAt(CGPoint(x: -1.5, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1.5, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -1, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -0.5, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: -0.5, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0.5, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 0.5, y: 0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: -1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1, y: 1.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1.5, y: -0.5), on: thisView, height: height)
//            placeImageAt(CGPoint(x: 1.5, y: 0.5), on: thisView, height: height)
//        default:
//            break
//        }
//    }
//
//    // The point in this function indicates the coordinates on the `thisView` parameter using standard cartesean coords with the origin centered in the middle of the view.
//    func placeImageAt(_ point: CGPoint, on thisView: UIView, height: CGFloat) {
//        let ratio = height / 500
//
//        thisView.layer.borderColor = UIColor.black.cgColor
//        thisView.layer.borderWidth = 2
//        let imageSize: CGFloat = ratio * 77
//        let imageSpacer: CGFloat = ratio * 4
//
//        var xConstant: CGFloat = 0
//        var yConstant: CGFloat = 0
//
//        switch point.x {
//        case -1.5: xConstant = -3 * (imageSize/2 + imageSpacer)
//        case -1: xConstant = -(imageSize + 2 * imageSpacer)
//        case -0.5: xConstant = -(imageSize/2 + imageSpacer)
//        case 0: xConstant = 0
//        case 0.5: xConstant = (imageSize/2 + imageSpacer)
//        case 1: xConstant = (imageSize + 2 * imageSpacer)
//        case 1.5: xConstant = 3 * (imageSize/2 + imageSpacer)
//        default:
//            return
//        }
//        switch point.y {
//        case -1.5: yConstant = 3 * (imageSize/2 + imageSpacer)
//        case -1: yConstant = (imageSize + 2 * imageSpacer)
//        case -0.5: yConstant = (imageSize/2 + imageSpacer)
//        case 0: yConstant = 0
//        case 0.5: yConstant = -(imageSize/2 + imageSpacer)
//        case 1: yConstant = -(imageSize + 2 * imageSpacer)
//        case 1.5: yConstant = -3 * (imageSize/2 + imageSpacer)
//        default:
//            return
//        }
//
//        let image = UIImageView(image: card?.image)
//        thisView.addSubview(image)
//        image.translatesAutoresizingMaskIntoConstraints = false
//        image.centerXAnchor.constraint(equalTo: thisView.centerXAnchor, constant: xConstant).isActive = true
//        image.centerYAnchor.constraint(equalTo: thisView.centerYAnchor, constant: yConstant).isActive = true
//        image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive = true
//        image.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
//    }
//}
