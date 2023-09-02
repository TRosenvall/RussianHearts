//
//  SpecialCardView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/19/23.
//

import UIKit

class SpecialCardView: UIView {

    var card: SpecialCard?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView(height: frame.height)
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    convenience init(card: SpecialCard, height: CGFloat) {
        self.init(frame: .zero)
        self.card = card
        setupView(height: height)
    }

    func setupView(height: CGFloat) {
        if let card {
            self.clipsToBounds = true

            // Gradient Background Color
            let gradientView = NumberGradientView(frame: self.frame)
            gradientView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(gradientView)
            gradientView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            gradientView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            gradientView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            gradientView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

            // Top Left Corner
            let topCornerImage = UIImageView(image: Assets.secondaryImage(for: card.type))
            topCornerImage.translatesAutoresizingMaskIntoConstraints = false
            topCornerImage.widthAnchor.constraint(equalTo: topCornerImage.heightAnchor).isActive = true

            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Rothenburg Decorative", size: 33) as Any,
                .baselineOffset: -2
            ]
            let topCornerTextField = UILabel()
            topCornerTextField.clipsToBounds = false
            topCornerTextField.attributedText = NSAttributedString(string: "The \(card.name)",
                                                                   attributes:  textAttributes)

            let topStackView: UIStackView = UIStackView()
            topStackView.addArrangedSubview(topCornerImage)
            topStackView.addArrangedSubview(topCornerTextField)

            topStackView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(topStackView)
            topStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
            topStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11).isActive = true
            topStackView.heightAnchor.constraint(equalToConstant: 55).isActive = true
            topStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11).isActive = true

            // Bottom Left Corner
            let bottomCornerImage = UIImageView(image: Assets.secondaryImage(for: card.type))
            bottomCornerImage.translatesAutoresizingMaskIntoConstraints = false
            bottomCornerImage.widthAnchor.constraint(equalTo: bottomCornerImage.heightAnchor).isActive = true

            let bottomCornerTextField = UILabel()
            bottomCornerTextField.clipsToBounds = false
            bottomCornerTextField.attributedText = NSAttributedString(string: "The \(card.name)",
                                                                      attributes:  textAttributes)

            let bottomStackView: UIStackView = UIStackView()
            bottomStackView.addArrangedSubview(bottomCornerTextField)
            bottomStackView.addArrangedSubview(bottomCornerImage)

            bottomStackView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(bottomStackView)
            bottomStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
            bottomStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11).isActive = true
            bottomStackView.heightAnchor.constraint(equalToConstant: 55).isActive = true
            bottomStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11).isActive = true
            bottomCornerTextField.textAlignment = .right

            // Middle View
            let iconView = UIView()
            iconView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(iconView)
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11).isActive = true
            iconView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11).isActive = true
            iconView.layer.borderWidth = 2
            iconView.layer.borderColor = UIColor.black.cgColor

            let image = UIImageView(image: card.image)
            iconView.addSubview(image)
            image.translatesAutoresizingMaskIntoConstraints = false
            image.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
            image.centerYAnchor.constraint(equalTo: iconView.centerYAnchor).isActive = true
            image.widthAnchor.constraint(equalTo: iconView.widthAnchor).isActive = true
            image.heightAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true
            image.alpha = 0.6

            let ratio = 22/500 * height
            self.layer.cornerRadius = ratio
        }
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setupView(height: 500)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupView(height: rect.height)
    }
}
