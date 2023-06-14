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
    @IBOutlet var player2StackView: UIStackView!
    @IBOutlet var player2NameTextField: UITextField!
    @IBOutlet var player2SpacerView: UIView!
    @IBOutlet var player3StackView: UIStackView!
    @IBOutlet var player3NameTextField: UITextField!
    @IBOutlet var player3ToggleSwitch: UISwitch!
    @IBOutlet var player4StackView: UIStackView!
    @IBOutlet var player4NameTextField: UITextField!
    @IBOutlet var player4ToggleSwitch: UISwitch!
    @IBOutlet var player5StackView: UIStackView!
    @IBOutlet var player5NameTextField: UITextField!
    @IBOutlet var player5ToggleSwitch: UISwitch!
    @IBOutlet var player6StackView: UIStackView!
    @IBOutlet var player6NameTextField: UITextField!
    @IBOutlet var player6ToggleSwitch: UISwitch!
    @IBOutlet var spacer1View: UIView!
    @IBOutlet var startGameButton: UIButton!
    @IBOutlet var spacer2View: UIView!

    // MARK: - Properties
    
    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        logoImageView.image = Assets.appIcon
        self.view.backgroundColor = Assets.backgroundColor
    }

    // MARK: - Actions

    @IBAction func startGameButtonAction(_ sender: Any) {
        let controller = GameViewController()
        self.present(controller, animated: false)
    }

    // MARK: - Helpers

}
