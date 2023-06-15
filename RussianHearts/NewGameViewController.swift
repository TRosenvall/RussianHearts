//
//  NewGameViewController.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/13/23.
//

import UIKit

class NewGameViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var newGameView: UIView!
    @IBOutlet var verticalStackView: UIStackView!
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var player1StackView: UIStackView!
    @IBOutlet var player1NameTextField: UITextField!
    @IBOutlet var player1SpacerView: UIView!
    @IBOutlet var player1ClearButton: UIButton!
    @IBOutlet var player2StackView: UIStackView!
    @IBOutlet var player2NameTextField: UITextField!
    @IBOutlet var player2SpacerView: UIView!
    @IBOutlet var player2ClearButton: UIButton!
    @IBOutlet var player3StackView: UIStackView!
    @IBOutlet var player3NameTextField: UITextField!
    @IBOutlet var player3ToggleSwitch: UISwitch!
    @IBOutlet var player3ClearButton: UIButton!
    @IBOutlet var player4StackView: UIStackView!
    @IBOutlet var player4NameTextField: UITextField!
    @IBOutlet var player4ToggleSwitch: UISwitch!
    @IBOutlet var player4ClearButton: UIButton!
    @IBOutlet var player5StackView: UIStackView!
    @IBOutlet var player5NameTextField: UITextField!
    @IBOutlet var player5ToggleSwitch: UISwitch!
    @IBOutlet var player5ClearButton: UIButton!
    @IBOutlet var player6StackView: UIStackView!
    @IBOutlet var player6NameTextField: UITextField!
    @IBOutlet var player6ToggleSwitch: UISwitch!
    @IBOutlet var player6ClearButton: UIButton!
    @IBOutlet var spacer1View: UIView!
    @IBOutlet var startGameButton: UIButton!
    @IBOutlet var spacer2View: UIView!

    // MARK: - Properties

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.image = Assets.appIcon
        self.view.backgroundColor = Assets.backgroundColor
        textFieldDidChange()
    }

    // MARK: - Actions

    @IBAction func player1NameTextFieldChanged(_ sender: Any) {
        textFieldDidChange()
    }

    @IBAction func player2NameTextFieldChanged(_ sender: Any) {
        textFieldDidChange()
    }

    @IBAction func player3NameTextFieldChanged(_ sender: Any) {
        textFieldDidChange()
    }

    @IBAction func player4NameTextFieldChanged(_ sender: Any) {
        textFieldDidChange()
    }

    @IBAction func player5NameTextFieldChanged(_ sender: Any) {
        textFieldDidChange()
    }

    @IBAction func player6NameTextFieldChanged(_ sender: Any) {
        textFieldDidChange()
    }

    @IBAction func player1ClearButtonTapped(_ sender: Any) {
        clearTextField(player1NameTextField)
        textFieldDidChange()
    }

    @IBAction func player2ClearButtonTapped(_ sender: Any) {
        clearTextField(player2NameTextField)
        textFieldDidChange()
    }

    @IBAction func player3ClearButtonTapped(_ sender: Any) {
        clearTextField(player3NameTextField)
        textFieldDidChange()
    }

    @IBAction func player4ClearButtonTapped(_ sender: Any) {
        clearTextField(player4NameTextField)
        textFieldDidChange()
    }

    @IBAction func player5ClearButtonTapped(_ sender: Any) {
        clearTextField(player5NameTextField)
        textFieldDidChange()
    }

    @IBAction func player6ClearButtonTapped(_ sender: Any) {
        clearTextField(player6NameTextField)
        textFieldDidChange()
    }

    @IBAction func startGameButtonAction(_ sender: Any) {
        guard let player1Name = player1NameTextField?.text,
              let player2Name = player2NameTextField?.text,
              let player3Name = player3NameTextField?.text,
              let player4Name = player4NameTextField?.text,
              let player5Name = player5NameTextField?.text,
              let player6Name = player6NameTextField?.text
        else {
            return
        }

        var players: [Player] = []
        if player1Name != "" {
            players.append(Player(name: player1Name))
        }
        if player2Name != "" {
            players.append(Player(name: player2Name))
        }
        if player3Name != "" {
            players.append(Player(name: player3Name))
        }
        if player4Name != "" {
            players.append(Player(name: player4Name))
        }
        if player5Name != "" {
            players.append(Player(name: player5Name))
        }
        if player6Name != "" {
            players.append(Player(name: player6Name))
        }

        Game.newGame(with: players)

        let controller = GameViewController()
        self.present(controller, animated: true)
    }

    // MARK: - Helpers

    func textFieldDidChange() {
        guard let player1Name = player1NameTextField?.text,
              let player2Name = player2NameTextField?.text,
              let player3Name = player3NameTextField?.text,
              let player4Name = player4NameTextField?.text,
              let player5Name = player5NameTextField?.text,
              let player6Name = player6NameTextField?.text
        else {
            return
        }

        var playersCount = 0
        if player1Name != "" {
            playersCount += 1
        }
        if player2Name != "" {
            playersCount += 1
        }
        if player3Name != "" {
            playersCount += 1
        }
        if player4Name != "" {
            playersCount += 1
        }
        if player5Name != "" {
            playersCount += 1
        }
        if player6Name != "" {
            playersCount += 1
        }

        print(playersCount)
        if playersCount < 2 {
            startGameButton.isEnabled = false
        } else {
            startGameButton.isEnabled = true
        }
    }

    func clearTextField(_ textfield: UITextField) {
        textfield.text = ""
    }
}
