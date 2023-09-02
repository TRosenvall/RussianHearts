//
//  ViewDeckViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/27/23.
//

import UIKit

class ViewDeckViewController: UIViewController {

    var cards: [Card] = {
        var cards: [Card] = []

        for value in CardValues.allCases {
            for suit in CardSuit.allCases {
                cards.append(NumberCard(value: value, suit: suit))
            }
        }

        for type in SpecialCardType.allCases {
            cards.append(SpecialCard(type: type))
        }

        return cards
    }()

    lazy var specialCardView = {
        let card = cards[0] as? SpecialCard ?? SpecialCard(type: .lowCard)
        let specialCardView = SpecialCardView(card: card, height: 500)
        specialCardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(specialCardView, at: 0)
        specialCardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        specialCardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        specialCardView.widthAnchor.constraint(equalTo: specialCardView.heightAnchor, multiplier: C.cardAspectRatio).isActive = true
        specialCardView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        specialCardView.isHidden = true

        return specialCardView
    }()

    lazy var numberCardView = {
        let card = cards[0] as? NumberCard ?? NumberCard(value: .one, suit: .sickles)
        let numberCardView = NumberCardView(card: card, height: 500)
        numberCardView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(numberCardView, at: 0)
        numberCardView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        numberCardView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        numberCardView.widthAnchor.constraint(equalTo: numberCardView.heightAnchor, multiplier: 62.0/88.0).isActive = true
        numberCardView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        numberCardView.isHidden = true

        return numberCardView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Assets.backgroundColor

        if let numberCard = cards[0] as? NumberCard {
            numberCardView.card = numberCard
            numberCardView.isHidden = false
            specialCardView.isHidden = true
            numberCardView.layoutIfNeeded()
        } else if let specialCard = cards[0] as? SpecialCard {
            specialCardView.card = specialCard
            specialCardView.isHidden = false
            numberCardView.isHidden = true
            specialCardView.layoutIfNeeded()
        }

        let dismissButton = UIButton(type: .system)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.backgroundColor = Assets.accentColor
        dismissButton.tintColor = UIColor.white
        self.view.addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dismissButton.setTitle("Back", for: .normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)

        let nextButton = UIButton(type: .system)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("", for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.tintColor = .clear
        self.view.addSubview(nextButton)
        nextButton.topAnchor.constraint(equalTo: specialCardView.topAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: specialCardView.bottomAnchor).isActive = true
        nextButton.leadingAnchor.constraint(equalTo: specialCardView.leadingAnchor).isActive = true
        nextButton.trailingAnchor.constraint(equalTo: specialCardView.trailingAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }

    @objc func dismissButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc func nextButtonTapped() {
        let firstCard = cards.remove(at: 0)
        cards.append(firstCard)

        DispatchQueue.main.async {
            if let numberCard = self.cards[0] as? NumberCard {
                self.numberCardView.card = numberCard
                self.numberCardView.isHidden = false
                self.specialCardView.isHidden = true
                self.numberCardView.layoutIfNeeded()
            } else if let specialCard = self.cards[0] as? SpecialCard {
                self.specialCardView.card = specialCard
                self.specialCardView.isHidden = false
                self.numberCardView.isHidden = true
                self.specialCardView.layoutIfNeeded()
            }
        }
    }
}
