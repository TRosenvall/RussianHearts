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
    @IBOutlet var numberOfPlayersStackView: UIStackView!
    @IBOutlet var numberOfPlayersLabel: UILabel!
    @IBOutlet var removePlayerButton: UIButton!
    @IBOutlet var playerCountLabel: UILabel!
    @IBOutlet var addPlayerButton: UIButton!
    @IBOutlet var startGameButton: UIButton!

    // MARK: - Properties

    // MARK: - Lifecycle Functions

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
