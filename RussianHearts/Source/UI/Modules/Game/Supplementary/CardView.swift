//
//  CardView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/6/24.
//

import SwiftUI

enum CardTappedState: Codable {
    case tapped
    case notTapped
}

enum CardSelectedState: Codable {
    case selected
    case notSelected
}

protocol CardViewDelegate {
    func tapped(_ cardView: CardView)
}

struct CardView: View {

    // MARK: - Properties

    var delegate: CardViewDelegate?
    var card: Card

    // If the card has the face showing or the back
    var isUpsideDown: Bool

    // If the card is tappable
    var isDisabled: Bool

    // If the card was disabled on the last turn
    var wasDisabled: Bool

    // If the card has been tapped and may be selected to be played, this is the raised position
    var tappedState: CardTappedState

    // If the card has been played but before the players turn has ended so they can still undo this.
    var selectedState: CardSelectedState

    // MARK: - Lifecycle

    // These have default properties set to have the card disabled and upside down, basically uninteractiable and
    // unknowable. Given that these will be updated each turn, these values will be tracked throughout the round.
    init(delegate: CardViewDelegate? = nil,
         card: Card,
         isUpsideDown: Bool = true,
         isDisabled: Bool = true,
         wasDisabled: Bool = false,
         tappedState: CardTappedState = .notTapped,
         selectedState: CardSelectedState = .notSelected
    ) {
        self.delegate = delegate
        self.card = card
        self.isUpsideDown = isUpsideDown
        self.isDisabled = isDisabled
        self.wasDisabled = wasDisabled
        self.tappedState = tappedState
        self.selectedState = selectedState
    }

    // MARK: - Views

    var body: some View {
        backgroundColor.overlay {
            RoundedRectangle(cornerRadius: 20)
                .inset(by: 5)
                .stroke(cardColor, lineWidth: borderWidth)
            ZStack {
                VStack(alignment: .center) {
                    HStack(alignment: .center) {
                        GeometryReader { geometry in
                            Text(cardText)
                                .font(.system(size: min(geometry.size.width, geometry.size.height)))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .minimumScaleFactor(0.1)
                                .foregroundStyle(cardColor)
                                .layoutPriority(1)
                        }
                        .padding()
                    }
                }
            }
        }
        .cornerRadius(20)
        .frame(width: cardRatio * cardHeight, height: cardHeight)
        .fixedSize()
    }
}

extension CardView {

    var cardHeight: CGFloat { 175 }
    // These should probably come through a theme, but they're just constants used in the card view itself.
    var cardRatio: CGFloat { 62.0/88.0 }
    var borderWidth: CGFloat { 3 }

    var cardColor: Color {
        if !isUpsideDown,
           let card = card.unwrapNumberCard(),
           let color = card.suit?.transformToColor().UI {
            return color
        }
        return UIColor.darkGray.UI
    }

    var cardText: String {
        if isUpsideDown {
            return "Card Back"
        }

        if let card = card.unwrapNumberCard(),
           let value = card.value?.rawValue {
            return value.description
        }

        if let card = card.unwrapSpecialCard(),
           let name = card.name {
            return name
        }

        return "Placeholder"
    }

    var backgroundColor: Color {
        Color.blend(color1: .white, color2: cardColor, intensity2: 0.03)
    }

    var cardSuit: CardSuit? {
        guard let card = card.unwrapNumberCard(),
              let suit = card.suit
        else { return nil }

        return suit
    }

    var cardValue: CardValue? {
        guard let card = card.unwrapNumberCard(),
              let value = card.value
        else { return nil }

        return value
    }

    var cardType: SpecialCardType? {
        guard let card = card.unwrapSpecialCard(),
              let type = card.type
        else { return nil }

        return type
    }

    // MARK: - Properties
//
//    var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            backgroundBorderView.layer.cornerRadius = newValue
//        }
//    }
//
//
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
//    lazy var disabledView: UIView = {
//        let view = UIView()
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        return view
//    }()
//
//    // Labels
//    lazy var valueLabel: UILabel = {
//        let label = UILabel()
//
//        label.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(label)
//
//        return label
//    }()
//
//    // Buttons
//    lazy var cardTappedButton: UIButton = {
//        let button = UIButton()
//
//        button.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(button)
//
//        button.addTarget(self,
//                         action: #selector(cardTappedButtonTapped),
//                         for: .touchUpInside)
//        return button
//    }()
//
//    // MARK: - Lifecycle
//    init(card: NumberCard) {
//        super.init(card: card)
//
//        self.translatesAutoresizingMaskIntoConstraints = false
//
//        _isUpsideDown = true
//        setupViews()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // MARK: - Actions
//    @objc func cardTappedButtonTapped() {
//        delegate?.tapped(self)
//    }
//
//    // MARK: - Helpers
//    func setupViews() {
//        // View
//        backgroundColor = .white
//
//        // Background Color View
//        backgroundBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        backgroundBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        backgroundBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//        backgroundBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//        backgroundBorderView.layer.borderColor = cardColor.cgColor
//        backgroundBorderView.layer.borderWidth = borderWidth
//        backgroundBorderView.layer.cornerRadius = cornerRadius
//
//        // Background Color View
//        backgroundColorView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        backgroundColorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        backgroundColorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//        backgroundColorView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//        backgroundColorView.backgroundColor = cardColor
//        backgroundColorView.alpha = 0.05
//
//        // Value Label
//        valueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 22).isActive = true
//        valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22).isActive = true
//        valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -22).isActive = true
//        valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -22).isActive = true
//        valueLabel.textAlignment = .center
//        valueLabel.textColor = cardColor
//        valueLabel.text = cardText
//        valueLabel.font = valueLabel.font.withSize(100)
//        valueLabel.minimumScaleFactor = 0.2
//        valueLabel.adjustsFontSizeToFitWidth = true
//        valueLabel.numberOfLines = 0
//
//        cardTappedButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        cardTappedButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        cardTappedButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        cardTappedButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    }
//
//    func addDisabledView() {
//        isDisabled = true
//        self.addSubview(disabledView)
//        disabledView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        disabledView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        disabledView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        disabledView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        disabledView.backgroundColor = .darkGray
//        disabledView.alpha = 0.66
//    }
//
//    func removeDisabledView() {
//        isDisabled = false
//        disabledView.removeFromSuperview()
//    }
}
